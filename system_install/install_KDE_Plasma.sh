#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

$install_command plasma ark dolphin dolphin-plugins kate kleopatra konsole okular kdegraphics-thumbnailers digikam ffmpegthumbs spectacle gwenview gnome-keyring packagekit-qt5
# ${prefix}systemctl enable sddm
