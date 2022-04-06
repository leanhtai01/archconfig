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
$install_command ttf-dejavu ttf-liberation noto-fonts-emoji ttf-cascadia-code adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts # ttf-fira-code ttf-roboto-mono ttf-hack

# browsers
$install_command chromium torbrowser-launcher # firefox-developer-edition

# editors
$install_command emacs gvim

# install doublecmd-qt5
$install_command doublecmd-qt5

# # install krusader and its all optional dependencies
# $install_command krusader
# $install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# programming packages
$install_command git dia github-cli kdiff3 # tidy npm
$install_command gdb cmake go valgrind clang gcc llvm gopls go-tools lldb

# tools
$install_command kruler keepassxc expect pacman-contrib curl dosfstools p7zip unarchiver bash-completion flatpak tree ibus archiso rclone rsync # fish clamav texlive-most

# setup connect android phone
$install_command mtpfs gvfs-mtp gvfs-gphoto2

# # install documentation for KDE Applications
# $install_command khelpcenter

# office and learning
$install_command libreoffice-fresh kolourpaint thunderbird

# multimedia
$install_command vlc gst-libav gst-plugins-good gst-plugins-ugly gst-plugins-bad # obs-studio

if [ $3 != "virtualbox" ]
then
    # tools
    $install_command transmission-gtk lm_sensors ntfs-3g gparted exfatprogs efitools # deja-dup wimlib bchunk cdrtools fuseiso sbsigntools filezilla

    # office and learning
    $install_command calibre kchmviewer foliate okular #goldendict

    # multimedia
    $install_command inkscape gimp # blender kdenlive frei0r-plugins handbrake handbrake-cli

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
