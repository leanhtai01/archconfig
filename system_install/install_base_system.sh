#!/bin/bash

# exit script immediately on error
set -e

# global variables
install_dev=
part=
size_of_ram=
rootpass1=
rootpass2=
userpass1=
userpass2=
newusername=
realname=
user_choice=
storagepass1=
storagepass2=

# make place to save original config files (if not exist)
original_config_files_path=$(dirname $0)/original_config_files
if [ ! -d "$original_config_files_path" ]
then
    mkdir $original_config_files_path
fi

# get user info
. ./get_user_info.sh

# update the system clock
timedatectl set-ntp true

# preparing disk for install
case $user_choice in
    1) # normal install
	. ./prepare_disk_normal_install.sh
	;;
    2) # lvm on luks
	. ./prepare_disk_lvm_on_luks.sh
	;;
    4) # dual-boot with Windows 10 (normal install)
	. ./prepare_disk_dual-boot_with_windows_10_normal_install.sh
	;;
    5) # dual-boot with Windows 10 (LVM on LUKS)
	. ./prepare_disk_dual-boot_with_windows_10_lvm_on_luks.sh
	;;
esac

# setup mirrors
cp /etc/pacman.d/mirrorlist $original_config_files_path
printf "mirrorlist: /etc/pacman.d/mirrorlist\n" > $original_config_files_path/original_path.txt
. ./setup_mirrors.sh

# install essential packages
pacstrap /mnt base base-devel linux linux-headers linux-firmware man-pages man-db

# CONFIGURE THE SYSTEM
# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# time zone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
arch-chroot /mnt hwclock --systohc

# localization
cp /mnt/etc/locale.gen $original_config_files_path
printf "locale.gen: /mnt/etc/locale.gen\n" >> $original_config_files_path/original_path.txt
linum=$(arch-chroot /mnt sed -n '/^#en_US.UTF-8 UTF-8  $/=' /etc/locale.gen)
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/locale.gen
arch-chroot /mnt locale-gen
echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf

# configure respositories for 64-bit system
cp /mnt/etc/pacman.conf $original_config_files_path
printf "pacman.conf: /mnt/etc/pacman.conf\n" >> $original_config_files_path/original_path.txt
linum=$(arch-chroot /mnt sed -n "/\\[multilib\\]/=" /etc/pacman.conf)
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/pacman.conf
((linum++))
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/pacman.conf

# network configuration
echo archlinux > /mnt/etc/hostname
echo "127.0.0.1    localhost" >> /mnt/etc/hosts
echo "::1          localhost" >> /mnt/etc/hosts
echo "127.0.1.1    archlinux.localdomain    archlinux" >> /mnt/etc/hosts
arch-chroot /mnt pacman -Syu --needed --noconfirm networkmanager
arch-chroot /mnt systemctl enable NetworkManager

# root password
echo -e "${rootpass1}\n${rootpass1}" | arch-chroot /mnt passwd

# add new user
arch-chroot /mnt useradd -G wheel,audio,lp,optical,storage,video,power -s /bin/bash -m $newusername -d /home/$newusername -c "$realname"
echo -e "${userpass1}\n${userpass1}" | arch-chroot /mnt passwd $newusername

# allow user in wheel group execute any command
cp /mnt/etc/sudoers $original_config_files_path
printf "sudoers: /mnt/etc/sudoers\n" >> $original_config_files_path/original_path.txt
linum=$(arch-chroot /mnt sed -n "/^# %wheel ALL=(ALL) ALL$/=" /etc/sudoers)
arch-chroot /mnt sed -i "${linum}s/^# //" /etc/sudoers # uncomment line

# configure mkinitcpio for encrypted system
cp /mnt/etc/mkinitcpio.conf $original_config_files_path
printf "mkinitcpio.conf: /mnt/etc/mkinitcpio.conf\n" >> $original_config_files_path/original_path.txt
re="[2356]"
if [[ "$user_choice" =~ $re ]]
then
    arch-chroot /mnt pacman -Syu --needed --noconfirm lvm2
    arch-chroot /mnt sed -i '/^HOOKS=(.*/s/ keyboard//' /etc/mkinitcpio.conf
    arch-chroot /mnt sed -i '/^HOOKS=(.*/s/autodetect/& keyboard keymap/' /etc/mkinitcpio.conf
    arch-chroot /mnt sed -i '/^HOOKS=(.*/s/block/& encrypt lvm2/' /etc/mkinitcpio.conf
    arch-chroot /mnt mkinitcpio -p linux
fi

# configure the bootloader
arch-chroot /mnt pacman -Syu --needed --noconfirm efibootmgr intel-ucode
arch-chroot /mnt bootctl install
echo "default archlinux" > /mnt/boot/loader/loader.conf
echo "timeout 5" >> /mnt/boot/loader/loader.conf
echo "console-mode keep" >> /mnt/boot/loader/loader.conf
echo "editor no" >> /mnt/boot/loader/loader.conf

echo "title Arch Linux" > /mnt/boot/loader/entries/archlinux.conf
echo "linux /vmlinuz-linux" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /intel-ucode.img" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/archlinux.conf

case $user_choice in
    1) # normal install
	rootuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}3)
	echo "options root=UUID=${rootuuidvalue} rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    2) # lvm on luks
	cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}2)
	echo "options cryptdevice=UUID=${cryptlvmuuidvalue}:cryptlvm root=/dev/sys_vol_group/root rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    4) # dual-boot with Windows 10 (normal install)
	rootuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}6)
	echo "options root=UUID=${rootuuidvalue} rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    5) # dual-boot with Windows 10 (LVM on LUKS)
	cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}5)
	echo "options cryptdevice=UUID=${cryptlvmuuidvalue}:cryptlvm root=/dev/sys_vol_group/root rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
esac

# setup hibernation
linum=$(arch-chroot /mnt sed -n '/^HOOKS=.*filesystems.*/=' /etc/mkinitcpio.conf)
arch-chroot /mnt sed -i "${linum}s/filesystems/& resume/" /etc/mkinitcpio.conf
arch-chroot /mnt mkinitcpio -p linux

swapuuidvalue=
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

echo "options resume=UUID=${swapuuidvalue}" >> /mnt/boot/loader/entries/archlinux.conf
