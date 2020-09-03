#!/bin/bash

set -e

# variables
efi_partnum=1
swap_partnum=5
root_partnum=6

# partition the disks
sgdisk -n 0:0:+`expr 2 \* $size_of_ram`G -t 0:8200 -c 0:"swap" /dev/$install_dev
sgdisk -n 0:0:0 -t 0:8304 -c 0:"root" /dev/$install_dev

# format the partition
dd if=/dev/zero of=/dev/${install_dev}${part}${swap_partnum} bs=4M count=1
dd if=/dev/zero of=/dev/${install_dev}${part}${root_partnum} bs=4M count=1
mkswap /dev/${install_dev}${part}${swap_partnum}
swapon /dev/${install_dev}${part}${swap_partnum}
mkfs.ext4 /dev/${install_dev}${part}${root_partnum}

# mount the filesystems
mount /dev/${install_dev}${part}${root_partnum} /mnt
case $bootloader in
    1)
	mkdir /mnt/boot
	mount /dev/${install_dev}${part}${efi_partnum} /mnt/boot
	;;
    2)
	mkdir -p /mnt/boot/efi
	mount /dev/${install_dev}${part}${efi_partnum} /mnt/boot/efi
	;;
esac
