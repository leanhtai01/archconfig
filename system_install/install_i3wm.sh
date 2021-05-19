#!/bin/bash

set -e

prefix=
newusername=$2
parent_dir=$(cd $(dirname $0)/..; pwd)

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

$install_command i3-wm i3lock i3status dmenu rxvt-unicode xorg-xinit feh xss-lock xorg-xinput network-manager-applet geoclue redshift

# configure i3
# get/create required files and dirs
${prefix}mkdir -p /home/${newusername}/.config

# copy required files
${prefix}cp -r $parent_dir/i3config/i3 /home/${newusername}/.config
${prefix}cp -r $parent_dir/i3config/i3status /home/${newusername}/.config
${prefix}cp -r $parent_dir/i3config/redshift /home/${newusername}/.config
${prefix}cp $parent_dir/data/tiling_window_manager/.Xresources /home/${newusername}

# change owner from root to user
${prefix}chown -R ${newusername}:${newusername} /home/${newusername}/.config
