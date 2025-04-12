/* Linker script tailored for BeagleY-AI (AM67A) R5F cores */

__TCM_START__       = 0x00000000;       /* ATCM memory region for vector table, startup */
__DDR_RESOURCE__    = 0xA2100000;       /* Carveout base for resource_table */
__DDR_CODE_START__  = 0xA2200000;       /* Carveout base for general firmware code/data/logs */

MEMORY
{
  TCMA (rwx)        : ORIGIN = __TCM_START__, LENGTH = 0x8000         /* 32 KB ATCM */
  DDR_RESOURCE (r)  : ORIGIN = __DDR_RESOURCE__, LENGTH = 0x1000      /* resource_table (4 KB) */
  DDR_CODE (rwx)    : ORIGIN = __DDR_CODE_START__, LENGTH = 0x100000  /* 1 MB for logs/data/etc. */
}

SECTIONS
{
  .text :
  {
    KEEP(*(.isr_vector))
    *(.text*)
    KEEP(*(.init))
    KEEP(*(.fini))

    /* .ctors */
    *crtbegin.o(.ctors)
    *crtbegin?.o(.ctors)
    *(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
    *(SORT(.ctors.*))
    *(.ctors)

    /* .dtors */
    *crtbegin.o(.dtors)
    *crtbegin?.o(.dtors)
    *(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)
    *(SORT(.dtors.*))
    *(.dtors)

    *(.rodata*)
    KEEP(*(.eh_frame*))
  } > TCMA

  .ARM.extab :
  {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } > TCMA

  __exidx_start = .;
  .ARM.exidx :
  {
    *(.ARM.exidx* .gnu.linkonce.armexidx.*)
  } > TCMA
  __exidx_end = .;

  __etext = ALIGN(4);

  .data : AT (__etext)
  {
    __data_start__ = .;
    *(vtable)
    *(.data*)

    . = ALIGN(4);
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP(*(.preinit_array))
    PROVIDE_HIDDEN (__preinit_array_end = .);

    . = ALIGN(4);
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP(*(SORT(.init_array.*)))
    KEEP(*(.init_array))
    PROVIDE_HIDDEN (__init_array_end = .);

    . = ALIGN(4);
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP(*(SORT(.fini_array.*)))
    KEEP(*(.fini_array))
    PROVIDE_HIDDEN (__fini_array_end = .);

    KEEP(*(.jcr*))
    . = ALIGN(4);
    __data_end__ = .;
  } > TCMA

  .bss :
  {
    . = ALIGN(4);
    __bss_start__ = .;
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    __bss_end__ = .;
  } > TCMA

  .heap (COPY):
  {
    __end__ = .;
    PROVIDE(end = .);
    *(.heap*)
    __HeapLimit = .;
  } > TCMA

  .stack_dummy (COPY):
  {
    *(.stack*)
  } > TCMA

  __StackTop = ORIGIN(TCMA) + LENGTH(TCMA);
  __StackLimit = __StackTop - SIZEOF(.stack_dummy);
  PROVIDE(__stack = __StackTop);

  ASSERT(__StackLimit >= __HeapLimit, "region TCMA overflowed with stack")

  /* These are carved out in the DT and expected by Linux remoteproc */

  .resource_table :
  {
    *(.resource_table*)
  } > DDR_RESOURCE

  .log_shared_mem :
  {
    *(.log_shared_mem*)
  } > DDR_CODE
}