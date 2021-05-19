#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

$install_command plasma-desktop plasma-wayland-session ark dolphin dolphin-plugins kate kleopatra konsole okular kdegraphics-thumbnailers ffmpegthumbs spectacle gwenview gnome-keyring
# ${prefix}systemctl enable sddm
