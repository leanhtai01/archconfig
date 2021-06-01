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
$install_command wimlib transmission-gtk keepassxc expect pacman-contrib deja-dup curl lm_sensors dosfstools ntfs-3g p7zip unarchiver gparted bash-completion bchunk ibus filezilla flatpak cdemu-client vhba-module-dkms cdrtools fuseiso efitools sbsigntools rclone

# install documentation for KDE Applications
$install_command khelpcenter

# install krusader and its all optional dependencies
$install_command krusader
$install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)
		   
# office and learning
$install_command calibre kchmviewer kolourpaint thunderbird libreoffice-fresh okular gimp inkscape

# multimedia
$install_command obs-studio vlc gst-libav gst-plugins-good gst-plugins-ugly gst-plugins-bad kdenlive frei0r-plugins handbrake handbrake-cli

# virtualbox
$install_command virtualbox virtualbox-guest-iso virtualbox-host-dkms
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 vboxusers
fi

# docker
$install_command docker docker-compose
${prefix}systemctl enable docker
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 docker
fi
