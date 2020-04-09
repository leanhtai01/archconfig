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

# let user choose device to install
lsblk
echo -n "Enter device to install: "
read install_dev

if [ $install_dev = nvme0n1 ]
then
	part=p
fi

# let user enter size of RAM to determine swap's size
echo -n "Enter size of RAM (in GB): "
read size_of_ram

# set root's password
echo "SET ROOT'S PASSWORD"
echo -n "Enter new root's password: "
read -s rootpass1
echo -n -e "\nRetype root's password: "
read -s rootpass2

while [ $rootpass1 != $rootpass2 ]
do
	echo -e "\nSorry, passwords do not match. Please try again!"
	echo -n "Enter root's password: "
	read -s rootpass1
	echo -n -e "\nRetype root's password: "
	read -s rootpass2
done
echo -e "\nroot's password set successfully!"

# create a new user
echo "CREATE A NEW USER"
echo -n "Enter username: "
read newusername
echo -n "Enter real name: "
read realname
echo -n "Enter ${newusername}'s password: "
read -s userpass1
echo -n -e "\nRetype $newusername's password: "
read -s userpass2

while [ $userpass1 != $userpass2 ]
do
	echo -e "\nSorry, passwords do not match. Please try again!"
	echo -n "Enter $newusername's password: "
	read -s userpass1
	echo -n -e "\nRetype $newusername's password: "
	read -s userpass2
done
echo -e "\n$newusername's password set successfully!"

# update the system clock
timedatectl set-ntp true

# partition the disks
# dd if=/dev/zero of=/dev/sda bs=512 count=1
# parted /dev/sda mklabel gpt
dd if=/dev/zero of=/dev/$install_dev bs=512 count=1
parted /dev/$install_dev mklabel gpt
parted /dev/$install_dev mkpart efi fat32 0% 1GiB
parted /dev/$install_dev set 1 esp on
parted /dev/$install_dev mkpart swap linux-swap 1GiB $((size_of_ram+1))GiB
parted /dev/$install_dev mkpart root ext4 $((size_of_ram+1))GiB 100%

# format the partitions
dd if=/dev/zero of=/dev/${install_dev}${part}1 bs=1M count=1
dd if=/dev/zero of=/dev/${install_dev}${part}2 bs=1M count=1
dd if=/dev/zero of=/dev/${install_dev}${part}3 bs=1M count=1
mkfs.fat -F32 /dev/${install_dev}${part}1
mkswap /dev/${install_dev}${part}2
swapon /dev/${install_dev}${part}2
mkfs.ext4 /dev/${install_dev}${part}3

# mount the file systems
mount /dev/${install_dev}${part}3 /mnt
mkdir /mnt/boot
mount /dev/${install_dev}${part}1 /mnt/boot

# select the mirrors
linum=$(sed -n '/^Server = http:\/\/f.archlinuxvn.org\/archlinux\/\$repo\/os\/\$arch$/=' /etc/pacman.d/mirrorlist) # find a line and get line number
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
echo -e "${rootpass1}\n${rootpass1}" | arch-chroot /mnt passwd

# add new user
arch-chroot /mnt useradd -G wheel,audio,lp,optical,storage,video,power -s /bin/bash -m $newusername -d /home/$newusername -c "$realname"
echo -e "${userpass1}\n${userpass1}" | arch-chroot /mnt passwd $newusername

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
rootuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}3)
echo "options root=UUID=${rootuuidvalue} rw" >> /mnt/boot/loader/entries/archlinux.conf

# setup hibernation
linum=$(arch-chroot /mnt sed -n '/^HOOKS=.*filesystems.*/=' /etc/mkinitcpio.conf)
arch-chroot /mnt sed -i "${linum}s/filesystems/& resume/" /etc/mkinitcpio.conf
arch-chroot /mnt mkinitcpio -p linux
swapuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}2)
echo "options resume=UUID=${swapuuidvalue}" >> /mnt/boot/loader/entries/archlinux.conf

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
