#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# install lutris and its all optional dependencies
$install_command lutris
$install_command $(printf "$(${prefix}pacman -Qi lutris)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# install wine and its all dependencies
$install_command wine
$install_command $(printf "$(${prefix}pacman -Qi wine)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# install steam
$install_command steam steam-native-runtime

# install playonlinux
$install_command playonlinux

# install some games and game's services
$install_command discord kigo bovo gnuchess wesnoth gnome-2048
