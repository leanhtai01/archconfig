#!/bin/bash

set -e

prefix=

if [ ! -z $2 ] && [ $2 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# install and configure some packages, services
# fonts
$install_command ttf-dejavu ttf-liberation noto-fonts-emoji ttf-hack

# audio
$install_command pulseaudio-alsa alsa-utils pulseaudio-bluetooth

# browsers
$install_command firefox-developer-edition torbrowser-launcher

# editors
$install_command emacs gvim

# programming packages
$install_command gdb cmake git go valgrind tk dia clang gcc python nodejs eslint npm github-cli

# tools
$install_command wimlib transmission-gtk keepassxc expect pacman-contrib curl kdiff3 lm_sensors dosfstools ntfs-3g p7zip unrar gparted wget bash-completion aircrack-ng gnome-calculator gnome-disk-utility
$install_command reflector pdftk youtube-dl efitools sbsigntools gnome-clocks # optional

# install documentation for KDE Applications
$install_command khelpcenter

# install krusader and its all optional dependencies
$install_command krusader # breeze-icons
$install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d: -f1)

# remote desktop
$install_command remmina libvncserver freerdp

# office and learning
$install_command calibre kchmviewer goldendict kolourpaint evince thunderbird
$install_command libreoffice-fresh gimp inkscape geogebra

# multimedia
$install_command obs-studio vlc kdenlive frei0r-plugins

# wireshark
$install_command wireshark-qt
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 wireshark
fi

# docker
$install_command docker docker-compose
${prefix}systemctl enable docker
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 docker
fi

# enable bluetooth service
${prefix}systemctl enable bluetooth
