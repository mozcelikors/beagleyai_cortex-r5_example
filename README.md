# (Extremely) Minimal Cortex-R5 remoteproc example for Beagley-AI

Based on https://github.com/kaofishy/bbai64_cortex-r5_example

Cortex-R5 "Hello World" on Beagley-AI, showing how to initialize a minimal remoteproc resource table with a working trace log. Be warned that this is only a proof-of-concept, and includes just enough code to get *something* up and running on the Cortex-R5 (meaning no initialization code for interrupts, cache, MPU, RAT, etc...)

Copy test.elf to the board

scp -r test.elf <USER>@<IP>:/lib/firmware

On device:

echo stop > /sys/class/remoteproc/remoteproc4/state
echo test.elf > /sys/class/remoteproc/remoteproc4/firmware
echo start > /sys/class/remoteproc/remoteproc4/state

cat /sys/kernel/debug/remoteproc/remoteproc4/trace0

If everything worked you should see "Hello world!" printed from the remoteproc trace log with the previous command.

This was tested on custom Yocto distro running on Beagley-AI board but I assume it will also for the BeagleBoard.org provided images.
