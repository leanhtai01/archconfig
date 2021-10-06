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
$install_command ttf-roboto-mono ttf-dejavu ttf-liberation noto-fonts-emoji ttf-hack adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts

# audio
$install_command pulseaudio-alsa alsa-utils

# browsers
$install_command firefox-developer-edition torbrowser-launcher #chromium

# editors
$install_command emacs gvim

# programming packages
$install_command git dia github-cli kdiff3 npm php-tidy tidy
$install_command gdb cmake go valgrind clang gcc llvm gopls

# install kdevelop and its all optional dependencies
$install_command kdevelop
$install_command $(printf "$(${prefix}pacman -Qi kdevelop)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# install qtcreator and its all optional dependencies
$install_command qtcreator
$install_command $(printf "$(${prefix}pacman -Qi qtcreator)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# tools
$install_command keepassxc expect pacman-contrib curl dosfstools p7zip unarchiver bash-completion flatpak tree fish ibus clamav texlive-most

# setup connect android phone
$install_command mtpfs gvfs-mtp gvfs-gphoto2

# install krusader and its all optional dependencies
$install_command krusader
$install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# install documentation for KDE Applications
$install_command khelpcenter

# office and learning
$install_command thunderbird libreoffice-fresh

# multimedia
$install_command obs-studio vlc gst-libav gst-plugins-good gst-plugins-ugly gst-plugins-bad

if [ $3 != "virtualbox" ]
then
    # tools
    $install_command wimlib transmission-gtk deja-dup lm_sensors ntfs-3g gparted exfatprogs bchunk cdrtools fuseiso efitools sbsigntools filezilla

    # office and learning
    $install_command calibre kchmviewer kolourpaint goldendict okular

    # multimedia
    $install_command kdenlive frei0r-plugins handbrake handbrake-cli

    # virtualbox
    $install_command virtualbox virtualbox-guest-iso virtualbox-host-dkms
    if [ ! -z $1 ]
    then
	${prefix}gpasswd -a $1 vboxusers
    fi
fi

# docker
$install_command docker docker-compose
${prefix}systemctl enable docker
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 docker
fi
