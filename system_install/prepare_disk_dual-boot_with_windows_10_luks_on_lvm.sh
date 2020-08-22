#!/bin/bash

set -e

# partition the disk
sgdisk -n 0:0:0 -t 0:8e00 -c 0:"lvm" /dev/$install_dev

# create physical volume
dd if=/dev/zero of=/dev/${install_dev}${part}4 bs=1M count=1
pvcreate /dev/${install_dev}${part}4

# create volume group
vgcreate sys_vol_group /dev/${install_dev}${part}4

# create logical volumes
lvcreate -L `expr 2 \* $size_of_ram`G sys_vol_group -n cryptswap
lvcreate -l +100%FREE sys_vol_group -n cryptroot

# encrypt and format root partition
printf "$storagepass1" | cryptsetup luksFormat --type luks2 /dev/sys_vol_group/cryptroot -
printf "$storagepass1" | cryptsetup open /dev/sys_vol_group/cryptroot root -

# format the partition
mkfs.ext4 /dev/mapper/root

# mount the filesystems
mount /dev/mapper/root /mnt
mkdir /mnt/boot
mount /dev/${install_dev}${part}1 /mnt/boot
