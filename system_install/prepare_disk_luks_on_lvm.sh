#!/bin/bash

set -e

# partition the disk
dd if=/dev/zero of=/dev/$install_dev bs=4M count=1
parted /dev/$install_dev mklabel gpt
sgdisk -Z /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:ef00 -c 0:"efi" /dev/$install_dev
sgdisk -n 0:0:0 -t 0:8e00 -c 0:"lvm" /dev/$install_dev

# create physical volume
dd if=/dev/zero of=/dev/${install_dev}${part}2 bs=4M count=1
pvcreate /dev/${install_dev}${part}2

# create volume group
vgcreate sys_vol_group /dev/${install_dev}${part}2

# create logical volumes
lvcreate -L `expr 2 \* $size_of_ram`G sys_vol_group -n cryptswap
lvcreate -l +100%FREE sys_vol_group -n cryptroot

# encrypt and format root partition
printf "$storagepass1" | cryptsetup luksFormat --type luks2 /dev/sys_vol_group/cryptroot -
printf "$storagepass1" | cryptsetup open /dev/sys_vol_group/cryptroot root -

# format the partitions
dd if=/dev/zero of=/dev/${install_dev}${part}1 bs=4M count=1
mkfs.fat -F32 /dev/${install_dev}${part}1
mkfs.ext4 /dev/mapper/root

# mount the filesystems
mount /dev/mapper/root /mnt
mkdir /mnt/boot
mount /dev/${install_dev}${part}1 /mnt/boot
