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

# get user info
. ./get_user_info.sh

# update the system clock
timedatectl set-ntp true

# preparing disk for install
. ./prepare_disk_normal_install.sh

# select the mirrors
linum=$(sed -n '/^Server = http:\/\/f.archlinuxvn.org\/archlinux\/\$repo\/os\/\$arch$/=' /etc/pacman.d/mirrorlist) # find a line and get line number
preferredmirror=$(sed -n "$linum"p /etc/pacman.d/mirrorlist) # get line know line number
sed -i '6 a ## My preferred mirrors' /etc/pacman.d/mirrorlist # insert line after
sed -i "7 a $preferredmirror" /etc/pacman.d/mirrorlist

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
linum=$(arch-chroot /mnt sed -n "/^# %wheel ALL=(ALL) ALL$/=" /etc/sudoers)
arch-chroot /mnt sed -i "${linum}s/^# //" /etc/sudoers # uncomment line

# configure the bootloader
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm efibootmgr intel-ucode
arch-chroot /mnt bootctl install
echo "default archlinux" > /mnt/boot/loader/loader.conf
echo "timeout 5" >> /mnt/boot/loader/loader.conf
echo "console-mode keep" >> /mnt/boot/loader/loader.conf
echo "editor no" >> /mnt/boot/loader/loader.conf

echo "title Arch Linux" > /mnt/boot/loader/entries/archlinux.conf
echo "linux /vmlinuz-linux" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /intel-ucode.img" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/archlinux.conf
rootuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}3)
echo "options root=UUID=${rootuuidvalue} rw" >> /mnt/boot/loader/entries/archlinux.conf

# setup hibernation
linum=$(arch-chroot /mnt sed -n '/^HOOKS=.*filesystems.*/=' /etc/mkinitcpio.conf)
arch-chroot /mnt sed -i "${linum}s/filesystems/& resume/" /etc/mkinitcpio.conf
arch-chroot /mnt mkinitcpio -p linux
swapuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}2)
echo "options resume=UUID=${swapuuidvalue}" >> /mnt/boot/loader/entries/archlinux.conf
