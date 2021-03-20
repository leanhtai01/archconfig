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
# $install_command modemmanager usb_modeswitch wvdial
# ${prefix}systemctl enable ModemManager

# browsers
$install_command chromium # firefox-developer-edition torbrowser-launcher opera

# editors
$install_command emacs gvim

# programming packages
$install_command gdb cmake git go valgrind tk dia clang gcc python github-cli intellij-idea-community-edition jdk-openjdk java-openjfx jdk8-openjdk java8-openjfx # netbeans devhelp glade gnome-builder gnome-devel-docs gnome-code-assistance gtk4 gtk-doc pycharm-community-edition nodejs eslint npm dotnet-sdk

# install kdevelop and its all optional dependencies
# $install_command kdevelop
# $install_command $(printf "$(${prefix}pacman -Qi kdevelop)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# install qtcreator and its all optional dependencies
# $install_command qtcreator
# $install_command $(printf "$(${prefix}pacman -Qi qtcreator)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# tools
$install_command wimlib transmission-gtk keepassxc expect pacman-contrib deja-dup curl kdiff3 lm_sensors dosfstools ntfs-3g p7zip unrar gparted wget bash-completion nautilus gnome-calculator gnome-disk-utility bchunk ibus nfs-utils samba filezilla flatpak cdemu-client vhba-module-dkms ddclient dnscrypt-proxy cdrtools fuseiso gprename pdftk efitools sbsigntools gnome-clocks # lsb-release grub grub-customizer clamav bleachbit reflector fish youtube-dl aircrack-ng

# install documentation for KDE Applications
$install_command khelpcenter

# install krusader and its all optional dependencies
$install_command krusader # breeze-icons
$install_command $(printf "$(${prefix}pacman -Qi krusader)" | sed -n '/^Optional Deps/,$p' | sed '/^Required By/q' | head -n -1 | cut -c19- | cut -d[ -f1 | cut -d: -f1)

# remote desktop
# $install_command remmina libvncserver freerdp

# office and learning
$install_command calibre kchmviewer goldendict kolourpaint evince thunderbird okular libreoffice-fresh # sweethome3d hexchat gnucash step librecad gimp inkscape geogebra

# multimedia
$install_command obs-studio vlc kdenlive frei0r-plugins handbrake handbrake-cli mkvtoolnix-gui # blender audacity aegisub kid3 pencil2d

# virtualbox
$install_command virtualbox virtualbox-guest-iso virtualbox-host-dkms
if [ ! -z $1 ]
then
    ${prefix}gpasswd -a $1 vboxusers
fi

# wireshark
# $install_command wireshark-qt
# if [ ! -z $1 ]
# then
#     ${prefix}gpasswd -a $1 wireshark
# fi

# docker
# $install_command docker docker-compose
# ${prefix}systemctl enable docker
# if [ ! -z $1 ]
# then
#     ${prefix}gpasswd -a $1 docker
# fi

# enable bluetooth service
${prefix}systemctl enable bluetooth
