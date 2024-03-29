#!/bin/bash

set -e

dev=$1
path_to_iso=$2
label="WIN11X64"
current_dir=$(dirname $0)

# let user choose device
if [ -z $dev ]
then
    lsblk
    read -e -p "Enter USB device (sda, sdb, sdX,...): " dev
fi

# let user choose iso file
if [ -z $path_to_iso ]
then
    read -e -p "Enter path to the iso: " path_to_iso
fi

# let user choose USB's label
if [ -z $label ]
then
    read -e -p "Enter USB's label: " label
fi

# format device
. $current_dir/make_fat32_usb.sh $dev $label

# mount device
mkdir bootable_usb
sudo mount /dev/${dev}1 bootable_usb

# extract iso file to device
. $current_dir/extract_win10_bootable_iso.sh $path_to_iso bootable_usb "y"

# remove temporary dirs
sudo umount bootable_usb
sudo rm -r bootable_usb

sleep 30
lsblk
udisksctl power-off -b /dev/$dev
lsblk

printf "Successfully making bootable usb Windows on ${dev}!\n"
