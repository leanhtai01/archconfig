#!/bin/bash

set -e

# variables
device=$1

# let user choose device to clean
if [ -z $device ]
then
    lsblk
    echo -n "Enter device to clean: "
    read device
fi

dd if=/dev/zero of=/dev/$device bs=4M count=1
sgdisk -Z /dev/$device
