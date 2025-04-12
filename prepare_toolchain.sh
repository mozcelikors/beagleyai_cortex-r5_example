#!/bin/bash

# Define variables
URL="https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi.tar.xz"
FILENAME=$(basename "$URL")
DEST_DIR="toolchain"

# Check if toolchain directory already exists
if [ -d "$DEST_DIR" ]; then
    echo "Directory '$DEST_DIR' already exists. Skipping download and extraction."
    exit 0
fi

# Download the file
echo "Downloading $FILENAME..."
wget -O "$FILENAME" "$URL"

# Create the toolchain directory
mkdir -p "$DEST_DIR"

# Extract the archive
echo "Extracting $FILENAME into $DEST_DIR..."
tar -xJf "$FILENAME" -C "$DEST_DIR" --strip-components=1

# Clean up the archive file
echo "Deleting $FILENAME..."
rm -f "$FILENAME"

echo "Toolchain setup complete in '$DEST_DIR/'"
