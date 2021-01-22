#!/bin/bash

set -e

prefix=

if [ ! -z $2 ] && [ $2 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# install and configure some packages, services
# fonts
$install_command ttf-dejavu ttf-liberation noto-fonts-emoji ttf-hack adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts

# audio
$install_command pulseaudio-alsa alsa-utils pulseaudio-bluetooth

# usb 3g modem
$install_command modemmanager usb_modeswitch wvdial
${prefix}systemctl enable ModemManager

# browsers
$install_command chromium torbrowser-launcher
$install_command firefox-developer-edition

# editors
$install_command emacs gvim

# programming packages
$install_command gdb cmake git go valgrind tk dia clang gcc python dotnet-sdk nodejs eslint npm
$install_command intellij-idea-community-edition pycharm-community-edition netbeans jdk-openjdk # optional

# install kdevelop and its all optional dependencies
$install_command kdevelop
$install_command $(printf "$(${prefix}pacman -Qi kdevelop)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d: -f1)

# install qtcreator and its all optional dependencies
$install_command qtcreator
$install_command $(printf "$(${prefix}pacman -Qi qtcreator)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d: -f1)

# tools
$install_command wimlib transmission-gtk keepassxc expect pacman-contrib deja-dup curl kdiff3 lm_sensors dosfstools ntfs-3g p7zip unrar gparted wget bash-completion aircrack-ng nautilus gnome-calculator gnome-disk-utility bchunk
$install_command reflector cdrtools fuseiso gprename pdftk fish youtube-dl efitools sbsigntools gnome-clocks # optional

# install documentation for KDE Applications
$install_command khelpcenter

# install krusader and its all optional dependencies
$install_command krusader breeze-icons
$install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d: -f1)

# remote desktop
$install_command remmina libvncserver freerdp

# office and learning
$install_command calibre kchmviewer goldendict kolourpaint evince thunderbird
$install_command libreoffice-fresh librecad gimp inkscape geogebra sweethome3d hexchat gnucash # optional

# multimedia
$install_command obs-studio vlc kdenlive frei0r-plugins
$install_command blender handbrake handbrake-cli audacity aegisub kid3 rhythmbox mkvtoolnix-gui pencil2d # optional

# virtualbox
$install_command virtualbox virtualbox-guest-iso virtualbox-host-dkms
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 vboxusers
fi

# wireshark
$install_command wireshark-qt
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 wireshark
fi

# docker
$install_command docker docker-compose
${prefix}systemctl enable docker
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 docker
fi

# games
$install_command steam steam-native-runtime 
$install_command discord kigo bovo gnuchess wesnoth # optional

# enable bluetooth service
${prefix}systemctl enable bluetooth
