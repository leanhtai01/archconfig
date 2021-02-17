#!/bin/bash

set -e

install_dev=$1
multiboot_efi_label="multiboot_efi"
win10_x64_label="win10_x64_installer"
win10_iso_name="Win10_20H2_v2_English_x64.iso"
current_dir=$(dirname $0)

# let user choose device
if [ -z $install_dev ]
then
    lsblk
    read -e -p "Enter USB device (sda, sdb, sdX,...): " install_dev
fi

# create partition for Windows 10
# size_of_part=$(du --block-size=1G "$win10_iso_name" | cut -f1)
sudo sgdisk -n 0:0:+10G -t 0:0700 -c 0:"$win10_x64_label" /dev/$install_dev

# format the partitions
sleep 10
sudo mkfs.ntfs -Q -L "$win10_x64_label" /dev/disk/by-partlabel/${win10_x64_label}

# configurating GRUB
sudo mount /dev/disk/by-partlabel/${multiboot_efi_label} /mnt
part_uuid=$(blkid -s UUID -o value /dev/disk/by-partlabel/${win10_x64_label})
sudo sed -i "/^[ \t]*set uuid=\"\"/s/\"\"/\"$part_uuid\"/" /mnt/boot/grub/grub.cfg
sudo umount /mnt

# mount device
mkdir win10_x64_part
sudo mount /dev/disk/by-partlabel/${win10_x64_label} win10_x64_part

# extract iso
$current_dir/extract_win10_bootable_iso.sh $win10_iso_name win10_x64_part

# remove temparary dirs
sudo umount win10_x64_part
sudo rm -r win10_x64_part

sleep 30
printf "Success making bootable Windows 10 on /dev/disk/by-partlabel/${win10_x64_label}\n"
