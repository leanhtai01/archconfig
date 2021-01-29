#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# $install_command baobab cheese eog evince file-roller gdm gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager gnome-control-center gnome-disk-utility gnome-keyring gnome-logs gnome-menus gnome-photos gnome-screenshot gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-terminal gnome-themes-extra mutter nautilus sushi seahorse seahorse-nautilus chrome-gnome-shell dconf-editor gnome-tweaks totem alacarte gedit gedit-plugins gnome-software gnome-software-packagekit-plugin gnome-getting-started-docs gnome-user-docs gnome-user-share gnome-font-viewer
# $install_command devhelp glade gnome-builder gnome-devel-docs gnome-code-assistance gtk4 gtk-doc
$install_command gnome gnome-extra seahorse seahorse-nautilus chrome-gnome-shell alacarte gedit-plugins gnome-software-packagekit-plugin
${prefix}systemctl enable gdm
