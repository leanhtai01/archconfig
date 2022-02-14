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
$install_command ttf-dejavu ttf-liberation noto-fonts-emoji ttf-hack ttf-cascadia-code # adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts ttf-fira-code ttf-roboto-mono

# browsers
$install_command torbrowser-launcher firefox-developer-edition #chromium

# editors
$install_command emacs

# install krusader and its all optional dependencies
$install_command krusader
# $install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# programming packages
$install_command git dia github-cli kdiff3 npm # tidy
$install_command gdb cmake go valgrind clang gcc llvm gopls go-tools lldb

# tools
$install_command kruler keepassxc expect pacman-contrib curl dosfstools p7zip unarchiver bash-completion flatpak tree ibus texlive-most archiso rclone rsync # fish clamav

# setup connect android phone
$install_command mtpfs gvfs-mtp gvfs-gphoto2

# install documentation for KDE Applications
$install_command khelpcenter

# office and learning
$install_command libreoffice-fresh kolourpaint # thunderbird

# multimedia
$install_command vlc gst-libav gst-plugins-good gst-plugins-ugly gst-plugins-bad obs-studio

if [ $3 != "virtualbox" ]
then
    # tools
    $install_command wimlib transmission-gtk lm_sensors ntfs-3g gparted exfatprogs bchunk cdrtools fuseiso efitools sbsigntools filezilla # deja-dup

    # office and learning
    $install_command calibre kchmviewer foliate #goldendict okular

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
