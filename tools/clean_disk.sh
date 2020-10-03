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

sudo wipefs -a /dev/$device
sudo sgdisk -Z /dev/$device
