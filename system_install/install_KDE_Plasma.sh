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
    $install_command plasma-desktop plasma-wayland-session ark dolphin dolphin-plugins kate konsole kdegraphics-thumbnailers ffmpegthumbs spectacle gwenview bluedevil khotkeys kinfocenter kscreen plasma-firewall plasma-nm
else
    # full
    $install_command plasma-meta kde-applications-meta plasma-wayland-session ark dolphin dolphin-plugins kate kleopatra konsole okular kdegraphics-thumbnailers ffmpegthumbs spectacle gwenview gnome-keyring
fi

${prefix}systemctl enable sddm
${prefix}systemctl enable bluetooth
