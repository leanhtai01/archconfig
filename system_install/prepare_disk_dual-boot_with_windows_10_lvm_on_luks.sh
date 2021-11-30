#!/bin/bash

set -e

# variables
efi_partnum=1
xbootldr_partnum=5
boot_partnum=5
luks_partnum=6

# partition the disk
case $bootloader in
    1) # systemd-boot
        sgdisk -n 0:0:+1G -t 0:ea00 -c 0:"XBOOTLDR" /dev/$install_dev
        wipefs -a /dev/${install_dev}${part}${xbootldr_partnum}
        mkfs.vfat -F32 /dev/${install_dev}${part}${xbootldr_partnum}
        ;;
    2) # GRUB (encrypted boot)
	sgdisk -n 0:0:+1G -t 0:8309 -c 0:"cryptboot" /dev/$install_dev
	;;
    3) # GRUB (non-encrypted boot)
	sgdisk -n 0:0:+1G -t 0:8300 -c 0:"boot" /dev/$install_dev
	;;
esac
sgdisk -n 0:0:0 -t 0:8309 -c 0:"cryptlvm" /dev/$install_dev

case $bootloader in
    1) # systemd-boot	
	# create the LUKS encrypted container
        wipefs -a /dev/${install_dev}${part}${luks_partnum}
	printf "$storagepass1" | cryptsetup luksFormat --type luks2 /dev/${install_dev}${part}${luks_partnum} -

	# open the container
	printf "$storagepass1" | cryptsetup open /dev/${install_dev}${part}${luks_partnum} cryptlvm -
	wipefs -a /dev/mapper/cryptlvm
	;;
    2) # GRUB (encrypted boot)
	# create encrypted boot
        wipefs -a /dev/${install_dev}${part}${boot_partnum}
	printf "$bootpass1" | cryptsetup luksFormat --type luks1 /dev/${install_dev}${part}${boot_partnum} -
	printf "$bootpass1" | cryptsetup open /dev/${install_dev}${part}${boot_partnum} cryptboot -
	wipefs -a /dev/mapper/cryptboot
	
	# create the LUKS encrypted container
        wipefs -a /dev/${install_dev}${part}${luks_partnum}
	printf "$storagepass1" | cryptsetup luksFormat --type luks2 /dev/${install_dev}${part}${luks_partnum} -

	# open the container
	printf "$storagepass1" | cryptsetup open /dev/${install_dev}${part}${luks_partnum} cryptlvm -
	wipefs -a /dev/mapper/cryptlvm
	;;
    3) # GRUB (non-encrypted boot)
	# create the LUKS encrypted container
        wipefs -a /dev/${install_dev}${part}${luks_partnum}
	printf "$storagepass1" | cryptsetup luksFormat --type luks2 /dev/${install_dev}${part}${luks_partnum} -

	# open the container
	printf "$storagepass1" | cryptsetup open /dev/${install_dev}${part}${luks_partnum} cryptlvm -
	wipefs -a /dev/mapper/cryptlvm
	;;
esac

# create a physical volume on top of the opened LUKS container
pvcreate /dev/mapper/cryptlvm

# create the volume group named sys_vol_group
vgcreate sys_vol_group /dev/mapper/cryptlvm

# create all logical volumes on the volume group
lvcreate -L `expr 2 \* $size_of_ram`G sys_vol_group -n swap
lvcreate -l +100%FREE sys_vol_group -n root

# format the partitions
case $bootloader in
    2) # GRUB (encrypted boot)
	mkfs.ext4 /dev/mapper/cryptboot
	;;
    3) # GRUB (non-encrypted boot)
	mkfs.ext4 /dev/${install_dev}${part}${boot_partnum}
	;;
esac
mkswap /dev/sys_vol_group/swap
swapon /dev/sys_vol_group/swap
mkfs.ext4 /dev/sys_vol_group/root

# mount the filesystems
mount /dev/sys_vol_group/root /mnt
case $bootloader in
    1) # systemd-boot
        mkdir /mnt/efi
	mkdir /mnt/boot
	mount /dev/${install_dev}${part}${efi_partnum} /mnt/efi
        mount /dev/${install_dev}${part}${xbootldr_partnum} /mnt/boot
	;;
    2) # GRUB (encrypted boot)
	mkdir /mnt/boot
	mount /dev/mapper/cryptboot /mnt/boot
	mkdir /mnt/boot/efi
	mount /dev/${install_dev}${part}${efi_partnum} /mnt/boot/efi
	;;
    3) # GRUB (non-encrypted boot)
	mkdir /mnt/boot
	mount /dev/${install_dev}${part}${boot_partnum} /mnt/boot
	mkdir /mnt/boot/efi
	mount /dev/${install_dev}${part}${efi_partnum} /mnt/boot/efi
	;;
esac
