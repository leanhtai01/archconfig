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

# mobile broadband modem management service
$install_command modemmanager usb_modeswitch wvdial
${prefix}systemctl enable ModemManager

# audio
$install_command pulseaudio-alsa alsa-utils

# browsers
$install_command chromium torbrowser-launcher firefox-developer-edition opera

# editors
$install_command emacs gvim

# programming packages
$install_command gdb cmake git go valgrind dia clang gcc python github-cli jdk-openjdk java-openjfx jdk8-openjdk java8-openjfx jupyterlab netbeans julia python-nltk python-pandas python-pip python-numpy python-scikit-learn tk dotnet-sdk nodejs eslint npm

# install kdevelop and its all optional dependencies
$install_command kdevelop
$install_command $(printf "$(${prefix}pacman -Qi kdevelop)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# install qtcreator and its all optional dependencies
$install_command qtcreator
$install_command $(printf "$(${prefix}pacman -Qi qtcreator)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# tools
$install_command wimlib transmission-gtk keepassxc expect pacman-contrib deja-dup curl kdiff3 lm_sensors dosfstools ntfs-3g p7zip unarchiver gparted wget bash-completion bchunk ibus nfs-utils samba filezilla flatpak cdemu-client vhba-module-dkms cdrtools fuseiso gprename pdftk efitools sbsigntools bleachbit clamav ddclient dnscrypt-proxy fish youtube-dl aircrack-ng reflector

# install documentation for KDE Applications
$install_command khelpcenter

# install krusader and its all optional dependencies
$install_command krusader
$install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# remote desktop
$install_command remmina libvncserver freerdp
		   
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
