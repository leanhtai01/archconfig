#!/bin/bash

set -e

prefix=

if [ ! -z $2 ] && [ $2 = "in_chroot" ]
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

# tools
$install_command gprename pdftk bleachbit aircrack-ng reflector youtube-dl nfs-utils samba clamav fish wget rclone

# remote desktop
$install_command remmina libvncserver freerdp

# office and learning
$install_command sweethome3d hexchat gnucash step librecad foliate geogebra goldendict okular

# multimedia
$install_command blender audacity aegisub kid3 pencil2d mkvtoolnix-gui

# wireshark
$install_command wireshark-qt
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 wireshark
fi
