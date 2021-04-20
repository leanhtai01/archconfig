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
$install_command chromium torbrowser-launcher

# editors
$install_command emacs gvim

# programming packages
$install_command gdb cmake git go valgrind dia clang gcc python github-cli intellij-idea-community-edition jdk-openjdk java-openjfx jdk8-openjdk java8-openjfx jupyterlab netbeans julia python-nltk

# tools
$install_command wimlib transmission-gtk keepassxc expect pacman-contrib deja-dup curl kdiff3 lm_sensors dosfstools ntfs-3g p7zip unrar gparted wget bash-completion bchunk ibus nfs-utils samba filezilla flatpak cdemu-client vhba-module-dkms cdrtools fuseiso gprename pdftk efitools sbsigntools bleachbit

# install documentation for KDE Applications
$install_command khelpcenter

# install krusader and its all optional dependencies
$install_command krusader
$install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# office and learning
$install_command calibre kchmviewer goldendict kolourpaint thunderbird libreoffice-fresh gimp

# multimedia
$install_command obs-studio vlc kdenlive frei0r-plugins handbrake handbrake-cli mkvtoolnix-gui

# virtualbox
$install_command virtualbox virtualbox-guest-iso virtualbox-host-dkms
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 vboxusers
fi
