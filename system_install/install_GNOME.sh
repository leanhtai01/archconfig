#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

$install_command baobab eog evince file-roller gdm gnome-calculator gnome-characters gnome-clocks gnome-control-center gnome-keyring gnome-logs gnome-screenshot gnome-system-monitor gnome-terminal gnome-themes-extra nautilus sushi seahorse seahorse-nautilus chrome-gnome-shell dconf-editor gnome-tweaks gedit gedit-plugins gnome-font-viewer totem
${prefix}systemctl enable gdm
${prefix}systemctl enable bluetooth
