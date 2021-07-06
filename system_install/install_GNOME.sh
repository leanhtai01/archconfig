#!/bin/bash

set -e

prefix=
desktop_install_type=$2

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

if [ $desktop_install_type = "core" ]
then
    # core
    $install_command baobab eog evince file-roller gdm gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager gnome-contacts gnome-control-center gnome-font-viewer gnome-keyring gnome-screenshot gnome-system-monitor gnome-terminal gnome-themes-extra nautilus sushi gnome-tweaks gedit gedit-plugins totem xdg-user-dirs-gtk seahorse seahorse-nautilus
else
    # full
    $install_command gnome gnome-extra gedit-plugins
fi

${prefix}systemctl enable gdm
${prefix}systemctl enable bluetooth
