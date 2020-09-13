#!/bin/bash

set -e

prefix=

if [ ! -z $3 ] && [ $3 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# install and configure some packages, services
# system packages
$install_command lm_sensors dosfstools ntfs-3g p7zip unrar

# fonts
$install_command ttf-dejavu ttf-liberation noto-fonts-emoji ttf-hack

# audio
$install_command pulseaudio-alsa alsa-utils pulseaudio-bluetooth

# desktop environment
$install_command xorg-server

# driver installation
case $1 in
    intel)
	$install_command lib32-vulkan-icd-loader vulkan-icd-loader vulkan-intel intel-media-driver lib32-vulkan-intel lib32-mesa mesa ocl-icd lib32-ocl-icd intel-compute-runtime
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
$install_command baobab cheese eog evince file-roller gdm gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager gnome-control-center gnome-disk-utility gnome-keyring gnome-logs gnome-menus gnome-photos gnome-screenshot gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-terminal gnome-themes-extra mutter nautilus sushi seahorse seahorse-nautilus chrome-gnome-shell khelpcenter dconf-editor gnome-tweaks
${prefix}systemctl enable gdm

# browsers
$install_command chromium

# editors
$install_command emacs gvim

# programming packages
$install_command gdb cmake git go valgrind tk dia clang gcc python

# tools
$install_command reflector wimlib transmission-gtk keepassxc expect pacman-contrib gprename pdftk

# office and learning
$install_command libreoffice-fresh calibre kchmviewer goldendict kolourpaint thunderbird librecad gimp inkscape geogebra sweethome3d

# multimedia
$install_command obs-studio vlc kdenlive frei0r-plugins blender handbrake handbrake-cli

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

# enable bluetooth service
${prefix}systemctl enable bluetooth
