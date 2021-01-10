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
sleep 2
lsblk
printf "Success clean device /dev/${device}!\n"
