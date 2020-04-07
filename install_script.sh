#!/bin/bash

# exit script immediately on error
set -e

# update the system clock
timedatectl set-ntp true

# let user choose device to install
lsblk
echo -n "Enter device to install: "
read install_dev

# partition the disks
# dd if=/dev/zero of=/dev/sda bs=512 count=1
# parted /dev/sda mklabel gpt
dd if=/dev/zero of=/dev/$install_dev bs=512 count=1
parted /dev/$install_dev mklabel gpt
parted /dev/$install_dev mkpart efi fat32 0% 1GiB
parted /dev/$install_dev set 1 esp on
parted /dev/$install_dev mkpart swap linux-swap 1GiB 32GiB
parted /dev/$install_dev mkpart root ext4 32GiB 100%

# # partition the disks (virtual machine)
# dd if=/dev/zero of=/dev/sda bs=512 count=1
# parted /dev/sda mklabel gpt
# parted /dev/sda mkpart efi fat32 0% 512MiB
# parted /dev/sda set 1 esp on
# parted /dev/sda mkpart swap linux-swap 512MiB 4608MiB
# parted /dev/sda mkpart root ext4 4608MiB 100%

# format the partitions
dd if=/dev/zero of=/dev/${install_dev}1 bs=1M count=1
dd if=/dev/zero of=/dev/${install_dev}2 bs=1M count=1
dd if=/dev/zero of=/dev/${install_dev}3 bs=1M count=1
mkfs.fat -F32 /dev/${install_dev}1
mkswap /dev/${install_dev}2
swapon /dev/${install_dev}2
mkfs.ext4 /dev/${install_dev}3

# # format the partitions (virtual machine)
# dd if=/dev/zero of=/dev/sda1 bs=1M count=1
# dd if=/dev/zero of=/dev/sda2 bs=1M count=1
# dd if=/dev/zero of=/dev/sda3 bs=1M count=1
# mkfs.fat -F32 /dev/sda1
# mkswap /dev/sda2
# swapon /dev/sda2
# mkfs.ext4 /dev/sda3

# mount the file systems
mount /dev/${install_dev}3 /mnt
mkdir /mnt/boot
mount /dev/${install_dev}1 /mnt/boot

# # mount the file systems (virtual machine)
# mount /dev/sda3 /mnt
# mkdir /mnt/boot
# mount /dev/sda1 /mnt/boot

# select the mirrors
linum=$(sed -n '/f.archlinuxvn.org/=' /etc/pacman.d/mirrorlist) # find a line and get line number
preferredmirror=$(sed -n "$linum"p /etc/pacman.d/mirrorlist) # get line know line number
sed -i '6 a ## My preferred mirrors' /etc/pacman.d/mirrorlist # insert line after
sed -i "7 a $preferredmirror" /etc/pacman.d/mirrorlist

# install essential packages
pacstrap /mnt base base-devel linux linux-firmware

# CONFIGURE THE SYSTEM
# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# time zone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
arch-chroot /mnt hwclock --systohc

# localization
linum=$(arch-chroot /mnt sed -n '/en_US.UTF-8/=' /etc/locale.gen | tail -1)
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/locale.gen
arch-chroot /mnt locale-gen
echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf

# configure respositories for 64-bit system
linum=$(arch-chroot /mnt sed -n "/#Include = \/etc\/pacman.d\/mirrorlist/=" /etc/pacman.conf | tail -1)
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/pacman.conf
((linum--))
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/pacman.conf

# network configuration
echo archlinux > /mnt/etc/hostname
echo "127.0.0.1    localhost" >> /mnt/etc/hosts
echo "::1          localhost" >> /mnt/etc/hosts
echo "127.0.1.1    archlinux.localdomain    archlinux" >> /mnt/etc/hosts

# root password
# echo -e "123\n123" | arch-chroot /mnt passwd

# add new user
arch-chroot /mnt useradd -G wheel,audio,lp,optical,storage,video,power -s /bin/bash -m leanhtai01 -d /home/leanhtai01 -c "Le Anh Tai"
# echo -e "123\n123" | arch-chroot /mnt passwd leanhtai01

# allow user in wheel group execute any command
linum=$(arch-chroot /mnt sed -n "/%wheel ALL=(ALL) ALL/=" /etc/sudoers)
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/sudoers # uncomment line
arch-chroot /mnt sed -i "${linum}s/^[ \t]*//" /etc/sudoers # trim leading spaces

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
uuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/nvme0n1p3)
# for virtual machine
# uuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/sda3)
echo "options root=UUID=${uuidvalue} rw" >> /mnt/boot/loader/entries/archlinux.conf

# install and configure some packages, services
# system packages
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm linux-headers lm_sensors ufw gparted dosfstools ntfs-3g p7zip unrar

# fonts
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm ttf-dejavu ttf-liberation adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts noto-fonts-emoji

# network
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm networkmanager modemmanager usb_modeswitch wvdial
arch-chroot /mnt systemctl enable NetworkManager
arch-chroot /mnt systemctl enable ModemManager

# audio
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm pulseaudio-alsa alsa-utils

# desktop environment
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm xorg-server xorg-xrandr lib32-vulkan-icd-loader vulkan-icd-loader vulkan-intel xf86-video-intel lib32-mesa mesa mesa-demos

# # GNOME
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm gnome alacarte file-roller seahorse gst-libav seahorse-nautilus gnome-clocks gnome-calendar rhythmbox gprename gnuchess transmission-gtk chrome-gnome-shell gedit gedit-plugins gnome-sound-recorder gnome-tweaks gnome-builder devhelp dconf-editor
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm gnome-extra
# arch-chroot /mnt systemctl enable gdm

# Plasma
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm plasma digikam ktorrent ark dolphin dolphin-plugins ffmpegthumbs gwenview kalarm kamoso kate kcalc kdegraphics-mobipocket kdegraphics-thumbnailers kdf khelpcenter kleopatra kmousetool knotes kolourpaint kompare konsole krdc krfb kruler ksystemlog ktimer kwalletmanager okular spectacle sweeper umbrello
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm kde-applications
arch-chroot /mnt systemctl enable sddm

# browsers
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm chromium
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm opera
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm firefox-developer-edition

# editors
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm atom
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm geany
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm nano
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm vi
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm emacs
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm gvim

# programming packages
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm gdb cmake jdk-openjdk jdk8-openjdk r swi-prolog qtcreator qt5-doc qt5-examples opencv opencv-samples git go dotnet-sdk lazarus-qt5 intellij-idea-community-edition pycharm-community-edition valgrind eclipse-java tk

# tools
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm wget youtube-dl reflector wimlib

# office and learning
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm librecad qcad lilypond gnucash octave
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm libreoffice-fresh gimp inkscape calibre klavaro goldendict kchmviewer geogebra freemind

# multimedia
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm obs-studio vlc
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm kdenlive frei0r-plugins audacity aegisub kid3 kodi

# virtualbox
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm virtualbox virtualbox-guest-iso virtualbox-host-dkms

# games
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm supertuxkart wesnoth minetest minetest-server teeworlds kbounce kigo bovo quadrapassel
