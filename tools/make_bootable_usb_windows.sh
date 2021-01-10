#!/bin/bash

set -e

dev=$1
path_to_iso=$2
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

# format device
. $current_dir/make_fat32_usb.sh $dev "WIN10X64"

# mount device
mkdir bootable_usb
sudo mount /dev/${dev}1 bootable_usb

# extract iso file to device
. $current_dir/extract_win10_bootable_iso.sh $path_to_iso bootable_usb

printf "Successfully making bootable usb Windows 10 on ${dev}!\n"
