#!/bin/bash

set -e

# partition the disks
wipefs -a /dev/$install_dev
sgdisk -Z /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:ef00 -c 0:"esp" /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:ea00 -c 0:"XBOOTLDR" /dev/$install_dev
sgdisk -n 0:0:+`expr 2 \* $size_of_ram`G -t 0:8200 -c 0:"swap" /dev/$install_dev
sgdisk -n 0:0:0 -t 0:8304 -c 0:"root" /dev/$install_dev

# format the partitions
wipefs -a /dev/${install_dev}${part}1
wipefs -a /dev/${install_dev}${part}2
wipefs -a /dev/${install_dev}${part}3
wipefs -a /dev/${install_dev}${part}4
mkfs.vfat -F32 /dev/${install_dev}${part}1
mkfs.vfat -F32 /dev/${install_dev}${part}2
mkswap /dev/${install_dev}${part}3
swapon /dev/${install_dev}${part}3
mkfs.ext4 /dev/${install_dev}${part}4

# mount the file systems
mount /dev/${install_dev}${part}4 /mnt
case $bootloader in
    1)
        mkdir /mnt/efi
	mkdir /mnt/boot
        mount /dev/${install_dev}${part}1 /mnt/efi
	mount /dev/${install_dev}${part}2 /mnt/boot
	;;
    2)
	;&
    3)
	mkdir -p /mnt/boot/efi
	mount /dev/${install_dev}${part}1 /mnt/boot/efi
	;;
esac
