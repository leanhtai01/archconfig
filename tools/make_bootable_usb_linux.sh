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

$current_dir/clean_disk.sh $device
sudo sgdisk -n 0:0:0 /dev/$device
sudo dd if=$path_to_iso of=/dev/$device bs=4M conv=sync
sleep 30
lsblk
udisksctl power-off -b /dev/$device
lsblk
printf "Successfully write ${path_to_iso} to ${dev}!\n"
