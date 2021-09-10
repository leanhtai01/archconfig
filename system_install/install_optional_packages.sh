#!/bin/bash

set -e

prefix=

if [ ! -z $2 ] && [ $2 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# tools
$install_command gprename pdftk bleachbit aircrack-ng reflector youtube-dl nfs-utils samba wget rclone

# remote desktop
$install_command remmina libvncserver freerdp

# office and learning
$install_command sweethome3d hexchat gnucash step librecad foliate geogebra inkscape gimp

# multimedia
$install_command blender audacity aegisub kid3 pencil2d mkvtoolnix-gui

# wireshark
$install_command wireshark-qt
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 wireshark
fi
