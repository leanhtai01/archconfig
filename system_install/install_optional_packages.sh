#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# editors
$install_command gvim

# programming packages
$install_command jdk8-openjdk r swi-prolog qtcreator qt5-doc qt5-examples opencv opencv-samples jdk-openjdk dotnet-sdk intellij-idea-community-edition pycharm-community-edition valgrind tk dia

# tools
$install_command cdrtools pacman-contrib fuseiso efitools sbsigntools gprename pdftk

# remote desktop
$install_command remmina libvncserver freerdp

# office and learning
$install_command librecad octave gimp inkscape geogebra sweethome3d

# multimedia
$install_command aegisub kid3 kodi digikam rhythmbox gst-libav blender handbrake handbrake-cli mkvtoolnix-gui pencil2d

# games
$install_command wesnoth steam steam-native-runtime discord

# wine
$install_command wine-staging lutris playonlinux giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs winetricks
