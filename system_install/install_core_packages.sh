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
$install_command ttf-dejavu ttf-liberation noto-fonts-emoji ttf-hack

# audio
$install_command pulseaudio-alsa alsa-utils

# browsers
$install_command firefox-developer-edition

# editors
$install_command emacs

# programming packages
$install_command gdb cmake git go valgrind dia clang gcc python github-cli jdk-openjdk openjdk-doc java-openjfx jdk8-openjdk openjdk8-doc java8-openjfx jupyterlab netbeans julia python-nltk python-pandas python-pip python-numpy python-scikit-learn tk dotnet-sdk nodejs eslint npm python-matplotlib rclone

# install kdevelop and its all optional dependencies
$install_command kdevelop
$install_command $(printf "$(${prefix}pacman -Qi kdevelop)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# install qtcreator and its all optional dependencies
$install_command qtcreator
$install_command $(printf "$(${prefix}pacman -Qi qtcreator)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# tools
$install_command wimlib transmission-gtk keepassxc expect pacman-contrib deja-dup curl kdiff3 lm_sensors dosfstools ntfs-3g p7zip unarchiver gparted wget bash-completion bchunk ibus nfs-utils samba filezilla flatpak cdemu-client vhba-module-dkms cdrtools fuseiso efitools sbsigntools clamav fish

# install documentation for KDE Applications
$install_command khelpcenter

# install krusader and its all optional dependencies
$install_command krusader
$install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)
		   
# office and learning
$install_command calibre kchmviewer goldendict kolourpaint thunderbird libreoffice-fresh gimp okular sweethome3d hexchat gnucash step librecad gimp inkscape geogebra foliate

# multimedia
$install_command obs-studio vlc kdenlive frei0r-plugins handbrake handbrake-cli mkvtoolnix-gui pencil2d blender audacity aegisub kid3

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
