#!/bin/bash

set -e

prefix=
newusername=$2

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

$install_command i3-wm i3lock i3status dmenu rxvt-unicode xorg-xinit feh xss-lock xorg-xinput network-manager-applet geoclue redshift

# configure i3
# get/create required files and dirs
${prefix}mkdir -p /home/${newusername}/tmp/archconfig
${prefix}mkdir -p /home/${newusername}/tmp/i3config
${prefix}git clone https://github.com/leanhtai01/archconfig /home/${newusername}/tmp/archconfig
${prefix}git clone https://github.com/leanhtai01/i3config /home/${newusername}/tmp/i3config
${prefix}mkdir -p /home/${newusername}/.config

# copy required files
${prefix}cp -r /home/${newusername}/tmp/i3config/i3 /home/${newusername}/.config
${prefix}cp -r /home/${newusername}/tmp/i3config/i3status /home/${newusername}/.config
${prefix}cp -r /home/${newusername}/tmp/i3config/redshift /home/${newusername}/.config
${prefix}cp /home/${newusername}/tmp/archconfig/data/tiling_window_manager/.Xresources /home/${newusername}

# change owner from root to user
${prefix}chown -R ${newusername}:${newusername} /home/${newusername}/tmp
${prefix}chown -R ${newusername}:${newusername} /home/${newusername}/.config

# remove tmp files
${prefix}rm -rf /home/${newusername}/tmp/*
