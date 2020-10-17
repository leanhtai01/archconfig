#!/bin/bash

set -e

# variables
device=$1

# let user choose device to clean
if [ -z $device ]
then
    lsblk
    echo -n "Enter device to clean (sda, sdb, sdX,...): "
    read device
fi

sudo wipefs -a /dev/$device
sudo sgdisk -Z /dev/$device
sleep 30
lsblk
udisksctl power-off -b /dev/$device
lsblk
printf "Success!\n"
