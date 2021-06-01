#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# core
$install_command eog evince file-roller gdm gnome-calculator gnome-control-center gnome-keyring gnome-screenshot gnome-system-monitor gnome-terminal gnome-themes-extra nautilus sushi gnome-tweaks gedit gedit-plugins totem xdg-user-dirs-gtk

# optional
# $install_command gnome-characters gnome-clocks gnome-logs seahorse seahorse-nautilus gnome-font-viewer dconf-editor baobab

# full
# $install_command gnome gnome-extra seahorse seahorse-nautilus gedit-plugins

${prefix}systemctl enable gdm
${prefix}systemctl enable bluetooth
