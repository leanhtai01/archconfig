#!/bin/bash

set -e

dev=$1
label=$2
current_dir=$(dirname $0)

# let user choose device
if [ -z $dev ]
then
    lsblk
    read -e -p "Enter USB device (sda, sdb, sdX,...): " dev
fi

# let user choose label
if [ -z $label ]
then
    read -e -p "Enter label: " label
fi

# format device
$current_dir/clean_disk.sh $dev
sudo sgdisk -n 0:0:0 /dev/$dev
sudo mkfs.fat -F32 /dev/${dev}1 -n "$label"
