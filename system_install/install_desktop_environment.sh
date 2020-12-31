#!/bin/bash

set -e

current_dir=$(dirname $0)
prefix=

if [ ! -z $2 ] && [ $2 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# install xorg-server
$install_command xorg-server xorg-xev acpilight

# allow users in the video group to change the brightness
printf 'ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", GROUP="video", MODE="0664"\n' >> /mnt/etc/udev/rules.d/backlight.rules

for de in $1
do
    case $de in
	GNOME)
	    . $current_dir/install_GNOME.sh $2
	    ;;
	KDEPlasma)
	    . $current_dir/install_KDE_Plasma.sh $2
	    ;;
	i3)
	    . $current_dir/install_i3wm.sh $2
	    ;;
    esac
done
