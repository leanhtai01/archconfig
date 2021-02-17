#!/bin/bash

set -e

install_dev=$1
multiboot_efi_label="multiboot_efi"
archlinux_label="arch_installer"
archlinux_iso_name="archlinux-2021.01.01-x86_64.iso"
current_dir=$(dirname $0)

# let user choose device
if [ -z $install_dev ]
then
    lsblk
    read -e -p "Enter USB device (sda, sdb, sdX,...): " install_dev
fi

# create partition for archlinux
sudo sgdisk -n 0:0:+1G -t 0:8300 -c 0:"$archlinux_label" /dev/$install_dev

# format the partitions
sleep 10
sudo mkfs.ext4 -L "$archlinux_label" /dev/disk/by-partlabel/${archlinux_label}

# configurating GRUB
sudo mount /dev/disk/by-partlabel/${multiboot_efi_label} /mnt
part_uuid=$(blkid -s UUID -o value /dev/disk/by-partlabel/${archlinux_label})
sudo sed -i "/^[ \t]*set uuid=\"\"/s/\"\"/\"$part_uuid\"/" /mnt/boot/grub/grub.cfg
sudo umount /mnt

# mount device
mkdir -p archlinux_part
sudo mount /dev/disk/by-partlabel/${archlinux_label} archlinux_part

# extract iso
sudo 7z x "$archlinux_iso_name" -o"archlinux_part"

# remove temporary dirs
sudo umount archlinux_part
sudo rm -r archlinux_part

sleep 30
printf "Success making bootable archlinux on /dev/disk/by-partlabel/${archlinux_label}\n"
