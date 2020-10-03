#!/bin/bash

set -e

# variables
efi_partnum=1
lvm_partnum=5

# partition the disk
sgdisk -n 0:0:0 -t 0:8e00 -c 0:"lvm" /dev/$install_dev

# create physical volume
wipefs -a /dev/${install_dev}${part}${lvm_partnum}
pvcreate /dev/${install_dev}${part}${lvm_partnum}

# create volume group
vgcreate sys_vol_group /dev/${install_dev}${part}${lvm_partnum}

# create logical volumes
lvcreate -L `expr 2 \* $size_of_ram`G sys_vol_group -n cryptswap
wipefs -a /dev/sys_vol_group/cryptswap
lvcreate -l +100%FREE sys_vol_group -n cryptroot
wipefs -a /dev/sys_vol_group/cryptroot

# encrypt and format root partition
printf "$storagepass1" | cryptsetup luksFormat --type luks2 /dev/sys_vol_group/cryptroot -
printf "$storagepass1" | cryptsetup open /dev/sys_vol_group/cryptroot root -
wipefs -a /dev/mapper/root

# format the partition
mkfs.ext4 /dev/mapper/root

# mount the filesystems
mount /dev/mapper/root /mnt
mkdir /mnt/boot
mount /dev/${install_dev}${part}${efi_partnum} /mnt/boot
