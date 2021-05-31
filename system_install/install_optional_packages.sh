#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# fonts
$install_command adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts

# mobile broadband modem management service
$install_command modemmanager usb_modeswitch wvdial
${prefix}systemctl enable ModemManager

# browsers
$install_command chromium torbrowser-launcher opera

# editors
$install_command gvim

# make some tools as optional
$install_command gprename pdftk bleachbit aircrack-ng reflector youtube-dl ddclient dnscrypt-proxy

# remote desktop
$install_command remmina libvncserver freerdp

# office and learning
$install_command sweethome3d hexchat gnucash step librecad foliate geogebra

# wireshark
$install_command wireshark-qt
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 wireshark
fi
