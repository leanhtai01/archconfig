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
$install_command ttf-fira-code ttf-roboto-mono ttf-dejavu ttf-liberation noto-fonts-emoji ttf-hack adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts

# install all optional dependencies of easyeffects
$install_command $(printf "$(${prefix}pacman -Qi easyeffects)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# browsers
$install_command torbrowser-launcher #chromium firefox-developer-edition

# editors
$install_command emacs

# programming packages
$install_command git dia github-cli kdiff3 npm php-tidy tidy
$install_command gdb cmake go valgrind clang gcc llvm gopls

# tools
$install_command keepassxc expect pacman-contrib curl dosfstools p7zip unarchiver bash-completion flatpak tree ibus clamav texlive-most archiso

# setup connect android phone
$install_command mtpfs gvfs-mtp gvfs-gphoto2

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
    $install_command calibre kchmviewer goldendict okular foliate

    # multimedia
    $install_command kdenlive frei0r-plugins handbrake handbrake-cli inkscape gimp blender

    # # virtualbox
    # $install_command virtualbox virtualbox-guest-iso virtualbox-host-dkms
    # if [ ! -z $1 ]
    # then
    #     ${prefix}gpasswd -a $1 vboxusers
    # fi
fi

# docker
$install_command docker docker-compose
${prefix}systemctl enable docker
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 docker
fi
