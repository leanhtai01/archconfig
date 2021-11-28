#!/bin/bash

set -e

# variables
efi_partnum=1
xbootldr_partnum=5
swap_partnum=5
root_partnum=6

case $bootloader in
    1) # systemd-boot
        swap_partnum=6
        root_partnum=7

        sgdisk -n 0:0:+1G -t 0:ea00 -c 0:"XBOOTLDR" /dev/$install_dev
        wipefs -a /dev/${install_dev}${part}${xbootldr_partnum}
        mkfs.vfat -F32 /dev/${install_dev}${part}${xbootldr_partnum}
        ;;
esac

# partition the disks
sgdisk -n 0:0:+`expr 2 \* $size_of_ram`G -t 0:8200 -c 0:"swap" /dev/$install_dev
sgdisk -n 0:0:0 -t 0:8304 -c 0:"root" /dev/$install_dev

# format the partition
wipefs -a /dev/${install_dev}${part}${swap_partnum}
wipefs -a /dev/${install_dev}${part}${root_partnum}
mkswap /dev/${install_dev}${part}${swap_partnum}
swapon /dev/${install_dev}${part}${swap_partnum}
mkfs.ext4 /dev/${install_dev}${part}${root_partnum}

# mount the filesystems
mount /dev/${install_dev}${part}${root_partnum} /mnt
case $bootloader in
    1)
        mkdir /mnt/efi
	mkdir /mnt/boot
        mount /dev/${install_dev}${part}${efi_partnum} /mnt/efi
	mount /dev/${install_dev}${part}${xbootldr_partnum} /mnt/boot
	;;
    2)
	;&
    3)
	mkdir -p /mnt/boot/efi
	mount /dev/${install_dev}${part}${efi_partnum} /mnt/boot/efi
	;;
esac
