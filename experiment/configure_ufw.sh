#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

$install_command ufw ufw-extras

if [ $2 = "GNOME" ]
then
    $install_command gufw
fi

$prefix systemctl enable ufw
$prefix ufw enable
