#!/bin/bash

# Check if the user is root (superuser)
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

# Ask the user to input the label of the USB device (e.g., PAIGESUSB)
read -p "Enter the label of the USB device: " usb_label

# List block devices and search for the USB device label
echo "Listing block devices..."
lsblk

# Automatically find the device associated with the user input label
usb_device=$(lsblk -o NAME,LABEL | grep "$usb_label" | awk '{print "/dev/" $1}')

# Check if the USB device was found
if [ -z "$usb_device" ]; then
    echo "Could not find the device labeled '$usb_label'. Please check the label and try again."
    exit 1
fi

# Display the device found
echo "Found USB device: $usb_device"

# Extract the partition name (e.g., /dev/sdb1) and the base device name (e.g., /dev/sdb)
base_device=$(echo $usb_device | sed 's/[0-9]*$//')

# Unmount the related block device
echo "Unmounting $usb_device..."
umount "$usb_device"

# Wait for the unmount to complete
sleep 2

# Ask where the image should be stored (e.g., Desktop)
read -p "Enter the output file path for the disk image: " output_file

# Verify that the output file path is not empty
if [ -z "$output_file" ]; then
    echo "No output file path provided. Exiting..."
    exit 1
fi

# Perform the bit-by-bit copy using dd
echo "Creating bit-by-bit copy of the USB drive..."
sudo dd if="$base_device" of="$output_file" bs=1024 count=204800 status=progress

# Inform the user that the process is complete
echo "The disk image has been successfully created at $output_file."
