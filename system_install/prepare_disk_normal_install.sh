#!/bin/bash

set -e

# partition the disks
# dd if=/dev/zero of=/dev/sda bs=512 count=1
sgdisk -Z /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:ef00 -c 0:"efi" /dev/$install_dev
sgdisk -n 0:0:+`expr 2 \* $size_of_ram`G -t 0:8200 -c 0:"swap" /dev/$install_dev
sgdisk -n 0:0:0 -t 0:8304 -c 0:"root" /dev/$install_dev

# format the partitions
dd if=/dev/zero of=/dev/${install_dev}${part}1 bs=1M count=1
dd if=/dev/zero of=/dev/${install_dev}${part}2 bs=1M count=1
dd if=/dev/zero of=/dev/${install_dev}${part}3 bs=1M count=1
mkfs.fat -F32 /dev/${install_dev}${part}1
mkswap /dev/${install_dev}${part}2
swapon /dev/${install_dev}${part}2
mkfs.ext4 /dev/${install_dev}${part}3

# mount the file systems
mount /dev/${install_dev}${part}3 /mnt
mkdir /mnt/boot
mount /dev/${install_dev}${part}1 /mnt/boot
