#!/bin/bash

set -e

prefix=

if [ ! -z $2 ] && [ $2 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# editor
$install_command gvim

# install krusader and its all optional dependencies
$install_command krusader
$install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# install kdevelop and its all optional dependencies
$install_command kdevelop
$install_command $(printf "$(${prefix}pacman -Qi kdevelop)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# install qtcreator and its all optional dependencies
$install_command qtcreator
$install_command $(printf "$(${prefix}pacman -Qi qtcreator)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# tools
$install_command gprename pdftk bleachbit aircrack-ng reflector youtube-dl nfs-utils samba wget rclone fish

# remote desktop
$install_command remmina libvncserver freerdp

# office and learning
$install_command sweethome3d hexchat gnucash step librecad geogebra stellarium

# multimedia
$install_command kid3 pencil2d

# wireshark
$install_command wireshark-qt
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 wireshark
fi
