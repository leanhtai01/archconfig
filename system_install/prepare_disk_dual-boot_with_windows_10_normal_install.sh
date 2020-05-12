#!/bin/bash

set -e

# partition the disks
sgdisk -n 0:0:+`expr 2 \* $size_of_ram`G -t 0:8200 -c 0:"swap" /dev/$install_dev
sgdisk -n 0:0:0 -t 0:8304 -c 0:"root" /dev/$install_dev

# format the partition
dd if=/dev/zero of=/dev/${install_dev}${part}5 bs=1M count=1
dd if=/dev/zero of=/dev/${install_dev}${part}6 bs=1M count=1
mkswap /dev/${install_dev}${part}5
swapon /dev/${install_dev}${part}5
mkfs.ext4 /dev/${install_dev}${part}6

# mount the filesystems
mount /dev/${install_dev}${part}6 /mnt
case $bootloader in
    1)
	mkdir /mnt/boot
	mount /dev/${install_dev}${part}2 /mnt/boot
	;;
    2)
	mkdir -p /mnt/boot/efi
	mount /dev/${install_dev}${part}2 /mnt/boot/efi
	;;
esac
