#!/bin/bash

set -e

# global variables
install_dev=
part=
size_of_ram=

# partition the disk
sgdisk -Z /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:ef00 -c 0:"efi" /dev/$install_dev
sgdisk -n 0:0:0 -t 0:8309 -c 0:"cryptlvm" /dev/$install_dev

# create the LUKS encrypted container
cryptsetup luksFormat --type luks2 /dev/${install_dev}${part}2

# open the container
cryptsetup open /dev/${install_dev}${part}2 cryptlvm

# create a physical volume on top of the opened LUKS container
pvcreate /dev/mapper/cryptlvm

# create the volume group named sys_vol_group
vgcreate sys_vol_group /dev/mapper/cryptlvm

# create all logical volumes on the volume group
lvcreate -L `expr 2 \* $size_of_ram`G sys_vol_group -n swap
lvcreate -l +100%FREE sys_vol_group -n root

# format the partitions
dd if=/dev/zero of=/dev/${install_dev}${part}1 bs=1M count=1
mkfs.fat -F32 /dev/${install_dev}${part}1
mkswap /dev/sys_vol_group/swap
swapon /dev/sys_vol_group/swap
mkfs.ext4 /dev/sys_vol_group/root

# mount the filesystems
mount /dev/sys_vol_group/root /mnt
mkdir /mnt/boot
mount /dev/${install_dev}${part}1 /mnt/boot
