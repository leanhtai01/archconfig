#!/bin/bash

set -e

# global variables
install_dev=

# let user choose device to make partitions
printf "MAKE PARTITIONS FOR WINDOWS 10\n"
if [ -z $install_dev ]
then
    lsblk
    echo -n "Enter device to install: "
    read install_dev
fi

# partition the disk
sgdisk -Z /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:2700 -c 0:"win_re" /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:ef00 -c 0:"efi" /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:0c01 -c 0:"ms_reserved" /dev/$install_dev
