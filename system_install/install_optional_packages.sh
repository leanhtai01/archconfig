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
$install_command jdk8-openjdk r swi-prolog qtcreator qt5-doc qt5-examples opencv opencv-samples jdk-openjdk dotnet-sdk intellij-idea-community-edition pycharm-community-edition glade gnome-builder gnome-code-assistance devhelp

# tools
$install_command cdrtools fuseiso efitools sbsigntools gprename pdftk

# remote desktop
$install_command remmina libvncserver freerdp

# office and learning
$install_command librecad octave gimp inkscape geogebra sweethome3d

# multimedia
$install_command aegisub kid3 rhythmbox gst-libav blender handbrake handbrake-cli mkvtoolnix-gui pencil2d gnome-sound-recorder

# games
$install_command wesnoth
