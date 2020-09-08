#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# install and configure some packages, services
# system packages
$install_command lm_sensors gparted dosfstools ntfs-3g p7zip unrar

# fonts
$install_command ttf-dejavu ttf-liberation noto-fonts-emoji ttf-hack ttf-anonymous-pro

# audio
$install_command pulseaudio-alsa alsa-utils pulseaudio-bluetooth

# desktop environment
$install_command xorg

# driver installation
case $3 in
    intel)
	$install_command lib32-vulkan-icd-loader vulkan-icd-loader vulkan-intel lib32-vulkan-intel lib32-vkd3d vkd3d xf86-video-intel lib32-mesa mesa mesa-demos
	;;
    amd)
	;;
    nvidia)
	;;
    virtualbox)
	$install_command virtualbox-guest-utils virtualbox-guest-dkms
	${prefix}systemctl enable vboxservice
	${prefix}gpasswd -a $2 vboxsf
	;;
    vmware)
	;;
esac

# GNOME
$install_command gnome seahorse seahorse-nautilus chrome-gnome-shell khelpcenter gnome-calendar dconf-editor gnome-tweaks
${prefix}systemctl enable gdm  

# browsers
$install_command chromium

# editors
$install_command emacs

# programming packages
$install_command gdb cmake git go valgrind tk dia

# tools
$install_command reflector wimlib transmission-gtk gnome-clocks alacarte file-roller hdparm keepassxc expect pacman-contrib

# office and learning
$install_command libreoffice-fresh calibre kchmviewer goldendict kolourpaint thunderbird

# multimedia
$install_command obs-studio vlc kdenlive frei0r-plugins

# virtualbox
$install_command virtualbox virtualbox-guest-iso virtualbox-host-dkms

# wireshark
$install_command wireshark-qt

# docker
$install_command docker
${prefix}systemctl enable docker

# add user to group wireshark, docker
if [ ! -z $2 ]
then
    ${prefix}gpasswd -a $2 wireshark
    ${prefix}gpasswd -a $2 docker
fi

# games
$install_command kigo bovo gnuchess gnome-chess quadrapassel

# enable bluetooth service
${prefix}systemctl enable bluetooth
