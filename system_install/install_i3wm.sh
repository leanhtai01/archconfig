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
${prefix}mkdir -p /home/${newusername}/git_repos/archconfig
${prefix}mkdir -p /home/${newusername}/git_repos/i3config
${prefix}git clone https://github.com/leanhtai01/archconfig /home/${newusername}/git_repos/archconfig
${prefix}git clone https://github.com/leanhtai01/i3config /home/${newusername}/git_repos/i3config
${prefix}mkdir -p /home/${newusername}/.config
${prefix}cp -r /home/${newusername}/git_repos/i3config/i3 /home/${newusername}/.config
${prefix}cp -r /home/${newusername}/git_repos/i3config/i3status /home/${newusername}/.config
${prefix}cp /home/${newusername}/git_repos/archconfig/data/tiling_window_manager/.Xresources /home/${newusername}
${prefix}chown -R ${newusername}:${newusername} /home/${newusername}/git_repos
${prefix}chown -R ${newusername}:${newusername} /home/${newusername}/.config
