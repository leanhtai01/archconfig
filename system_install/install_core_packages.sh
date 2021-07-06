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
$install_command pulseaudio-alsa alsa-utils

# browsers
$install_command firefox-developer-edition

# editors
$install_command emacs

# programming packages
$install_command git dia github-cli kdiff3

# tools
$install_command keepassxc expect pacman-contrib curl dosfstools p7zip unarchiver bash-completion ibus flatpak tree

# install documentation for KDE Applications
$install_command khelpcenter

# office and learning
$install_command thunderbird libreoffice-fresh

# multimedia
$install_command obs-studio vlc gst-libav gst-plugins-good gst-plugins-ugly gst-plugins-bad

if [ $3 != "virtualbox" ]
then
    # tools
    $install_command wimlib transmission-gtk deja-dup lm_sensors ntfs-3g gparted bchunk cdemu-client vhba-module-dkms cdrtools fuseiso efitools sbsigntools clamav filezilla

    # office and learning
    $install_command calibre kchmviewer kolourpaint goldendict okular

    # multimedia
    $install_command kdenlive frei0r-plugins handbrake handbrake-cli
    
    # virtualbox
    $install_command virtualbox virtualbox-guest-iso virtualbox-host-dkms
    if [ ! -z $1 ]
    then
	${prefix}gpasswd -a $1 vboxusers
    fi
fi

# docker
$install_command docker docker-compose
${prefix}systemctl enable docker
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 docker
fi
