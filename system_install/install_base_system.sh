#!/bin/bash

# exit script immediately on error
set -e

# global variables
current_dir=$(dirname $0)
parent_dir=$(cd $(dirname $0)/..; pwd)
install_dev=
other_storage_dev= # (sda, sdb, sdc, mmcblk0,...)
part=
size_of_ram=16
rootpass1=
rootpass2=
userpass1=
userpass2=
newusername=
realname="Lê Anh Tài"
user_choice=2
storagepass1=
storagepass2=
bootpass1=
bootpass2=
bootloader=1 # 1 - systemd-boot, 2 - GRUB
swapuuidvalue=
setupsecureboot=n
setupkeytool=y
desktop_environment="GNOME" # {GNOME, KDEPlasma, i3, none}
gpu=intel # {intel, amd, nvidia, virtualbox, vmware}
hostname="archlinux"

# get user info
. $current_dir/get_user_info.sh

# update the system clock
timedatectl set-ntp true

# clean install device
re="123"
if [[ $user_choice =~ $re ]]
then
    $parent_dir/tools/clean_disk.sh $install_dev
fi

# clean other storage device in system (if exists)
for dev in $other_storage_dev
do
    if [ -b /dev/$dev ]
    then
	$parent_dir/tools/clean_disk.sh $dev
    fi
done

# preparing disk for install
case $user_choice in
    1) # normal install
	. $current_dir/prepare_disk_normal_install.sh
	;;
    2) # lvm on luks
	. $current_dir/prepare_disk_lvm_on_luks.sh
	;;
    3) # luks on lvm
	. $current_dir/prepare_disk_luks_on_lvm.sh
	;;
    4) # dual-boot with Windows 10 (normal install)
	. $current_dir/prepare_disk_dual-boot_with_windows_10_normal_install.sh
	;;
    5) # dual-boot with Windows 10 (LVM on LUKS)
	. $current_dir/prepare_disk_dual-boot_with_windows_10_lvm_on_luks.sh
	;;
    6) # dual-boot with Windows 10 (LUKS on LVM)
	. $current_dir/prepare_disk_dual-boot_with_windows_10_luks_on_lvm.sh
	;;
esac

# setup mirrors
. $current_dir/setup_mirrors.sh

# install essential packages
pacstrap /mnt base base-devel linux linux-headers linux-firmware man-pages man-db

# CONFIGURE THE SYSTEM
# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# time zone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
arch-chroot /mnt hwclock --systohc

# localization
linum=$(arch-chroot /mnt sed -n '/^#en_US.UTF-8 UTF-8  $/=' /etc/locale.gen)
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/locale.gen
arch-chroot /mnt locale-gen
echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf

# configure respositories for 64-bit system
linum=$(arch-chroot /mnt sed -n "/\\[multilib\\]/=" /etc/pacman.conf)
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/pacman.conf
((linum++))
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/pacman.conf

# network configuration
echo "$hostname" > /mnt/etc/hostname
echo "127.0.0.1    localhost" >> /mnt/etc/hosts
echo "::1          localhost" >> /mnt/etc/hosts
echo "127.0.1.1    $hostname.localdomain    $hostname" >> /mnt/etc/hosts
arch-chroot /mnt pacman -Syu --needed --noconfirm networkmanager dhcpcd iwd
arch-chroot /mnt systemctl enable NetworkManager

# root password
echo -e "${rootpass1}\n${rootpass1}" | arch-chroot /mnt passwd

# add new user
arch-chroot /mnt useradd -G wheel,audio,lp,optical,storage,disk,video,power -s /bin/bash -m $newusername -d /home/$newusername -c "$realname"
echo -e "${userpass1}\n${userpass1}" | arch-chroot /mnt passwd $newusername

# allow user in wheel group execute any command
linum=$(arch-chroot /mnt sed -n "/^# %wheel ALL=(ALL) ALL$/=" /etc/sudoers)
arch-chroot /mnt sed -i "${linum}s/^# //" /etc/sudoers # uncomment line

# Reduce the number of times re-enter password using sudo
arch-chroot /mnt sed -i "$(sed -n "/^# Defaults\!.*/=" /etc/sudoers | tail -1) a Defaults timestamp_timeout=20" /etc/sudoers

# configure mkinitcpio for encrypted system
re="[2356]"
if [[ "$user_choice" =~ $re ]]
then
    arch-chroot /mnt pacman -Syu --needed --noconfirm lvm2
    arch-chroot /mnt sed -i '/^HOOKS=(.*/s/ keyboard//' /etc/mkinitcpio.conf
    arch-chroot /mnt sed -i '/^HOOKS=(.*/s/autodetect/& keyboard keymap/' /etc/mkinitcpio.conf
    arch-chroot /mnt sed -i '/^HOOKS=(.*/s/block/& encrypt lvm2/' /etc/mkinitcpio.conf
    arch-chroot /mnt mkinitcpio -p linux
fi

# setup hibernation
re="[36]"
if [[ ! $user_choice =~ $re ]] # not setup hibernation for LUKS on LVM
then
    linum=$(arch-chroot /mnt sed -n '/^HOOKS=.*filesystems.*/=' /etc/mkinitcpio.conf)
    arch-chroot /mnt sed -i "${linum}s/filesystems/& resume/" /etc/mkinitcpio.conf
    arch-chroot /mnt mkinitcpio -p linux
fi

# get swapuuidvalue
case $user_choice in
    1) # normal install
	swapuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}2)
	;;
    4) # dual-boot with Windows 10 (normal install)
	swapuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}5)
	;;
    2) # lvm on luks
	;&
    5) # dual-boot with Windows 10 (LVM on LUKS)
	swapuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/sys_vol_group/swap)
	;;
esac

# configure the bootloader
arch-chroot /mnt pacman -Syu --needed --noconfirm efibootmgr intel-ucode

if [ $setupkeytool = "y" ]
then    
    . $current_dir/setup_KeyTool.sh
fi

case $bootloader in
    1)
	. $current_dir/configure_systemd-boot.sh
	;;
    2)
	;&
    3)
	. $current_dir/configure_grub.sh
	;;
esac

# configure fstab and crypttab for swap (LUKS on LVM)
re="[36]"
if [[ $user_choice =~ $re ]]
then
    # crypttab
    printf "swap    /dev/sys_vol_group/cryptswap    /dev/urandom    swap,cipher=aes-cbc-essiv:sha256,size=256\n" >> /mnt/etc/crypttab

    # fstab
    printf "/dev/mapper/swap    none    swap    sw    0 0\n" >> /mnt/etc/fstab
fi

if [ $setupsecureboot = "y" ]
then    
    . $current_dir/setup_secure_boot.sh
fi

