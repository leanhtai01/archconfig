#!/bin/bash

set -e

install_dev=$1
part=
multiboot_efi_label="multiboot_efi"
current_dir=$(dirname $0)

# let user choose device
if [ -z $install_dev ]
then
    lsblk
    read -e -p "Enter USB device (sda, sdb, sdX,...): " install_dev
fi

# format device
$current_dir/clean_disk.sh $install_dev

# create efi parition for GRUB
sudo sgdisk -n 0:0:+1G -t 0:ef00 -c 0:"$multiboot_efi_label" /dev/$install_dev

# format the partitions
sudo wipefs -a /dev/${install_dev}${part}1
sudo mkfs.fat -F32 /dev/${install_dev}${part}1

# installing GRUB
sudo mount /dev/${install_dev}${part}1 /mnt
sudo mkdir -p /mnt/boot
sudo grub-install --target=x86_64-efi --removable --boot-directory=/mnt/boot --efi-directory=/mnt #--bootloader-id="multiboot-os-installer"

# configurating GRUB
sudo mkdir -p /mnt/boot/grub
sudo cp grub.cfg.template /mnt/boot/grub/grub.cfg

# unmount partition after done
sudo umount /mnt
