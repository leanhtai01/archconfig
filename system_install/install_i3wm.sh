#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

$install_command i3-wm i3blocks i3lock i3status dmenu rxvt-unicode xorg-xinit feh network-manager-applet
