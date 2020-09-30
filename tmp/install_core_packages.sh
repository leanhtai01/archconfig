#!/bin/bash

set -e

prefix=

if [ ! -z $3 ] && [ $3 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# install and configure some packages, services
# fonts
$install_command ttf-dejavu ttf-liberation noto-fonts-emoji ttf-hack # adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts

# audio
$install_command pulseaudio-alsa alsa-utils pulseaudio-bluetooth

# desktop environment
$install_command xorg-server

# driver installation
case $1 in
    intel)
	$install_command lib32-vulkan-icd-loader vulkan-icd-loader vulkan-intel intel-media-driver lib32-vulkan-intel lib32-mesa mesa ocl-icd lib32-ocl-icd intel-compute-runtime
	;;
    amd)
	;;
    nvidia)
	;;
    virtualbox)
	$install_command virtualbox-guest-utils virtualbox-guest-dkms
	${prefix}systemctl enable vboxservice
	${prefix}gpasswd -a $2 vboxsf
	;;
    vmware)
	;;
esac

# # usb 3g modem
# $install_command modemmanager usb_modeswitch wvdial
# ${prefix}systemctl enable ModemManager

# GNOME
$install_command baobab cheese eog evince file-roller gdm gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager gnome-control-center gnome-disk-utility gnome-keyring gnome-logs gnome-menus gnome-photos gnome-screenshot gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-terminal gnome-themes-extra mutter nautilus sushi seahorse seahorse-nautilus chrome-gnome-shell khelpcenter dconf-editor gnome-tweaks
${prefix}systemctl enable gdm

# browsers
$install_command chromium # firefox-developer-edition torbrowser-launcher

# editors
$install_command emacs # gvim

# # programming packages
# $install_command gdb cmake git go valgrind tk dia clang gcc python jdk-openjdk dotnet-sdk intellij-idea-community-edition pycharm-community-edition

# # tools
# $install_command reflector wimlib transmission-gtk keepassxc expect pacman-contrib gprename pdftk deja-dup curl kdiff3 lm_sensors dosfstools ntfs-3g p7zip unrar gparted wget youtube-dl cdrtools fuseiso efitools sbsigntools

# # remote desktop
# $install_command remmina libvncserver freerdp

# # office and learning
# $install_command libreoffice-fresh calibre kchmviewer goldendict kolourpaint thunderbird librecad gimp inkscape geogebra sweethome3d hexchat gnucash

# # multimedia
# $install_command obs-studio vlc kdenlive frei0r-plugins blender handbrake handbrake-cli audacity aegisub kid3 rhythmbox mkvtoolnix-gui pencil2d

# # virtualbox
# $install_command virtualbox virtualbox-guest-iso virtualbox-host-dkms
# if [ ! -z $2 ]
# then
#     ${prefix}gpasswd -a $2 vboxusers
# fi

# # wireshark
# $install_command wireshark-qt
# if [ ! -z $2 ]
# then
#     ${prefix}gpasswd -a $2 wireshark
# fi

# # docker
# $install_command docker
# ${prefix}systemctl enable docker
# if [ ! -z $2 ]
# then
#     ${prefix}gpasswd -a $2 docker
# fi

# # games
# $install_command kigo bovo gnuchess wesnoth steam steam-native-runtime discord

# # enable bluetooth service
# ${prefix}systemctl enable bluetooth
