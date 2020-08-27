#!/bin/bash

set -e

# system packages
arch-chroot /mnt pacman -Syu --needed --noconfirm smartmontools screen

# usb 3g modem
arch-chroot /mnt pacman -Syu --needed --noconfirm modemmanager usb_modeswitch wvdial
arch-chroot /mnt systemctl enable ModemManager

# browsers
arch-chroot /mnt pacman -Syu --needed --noconfirm firefox-developer-edition opera torbrowser-launcher

# editors
arch-chroot /mnt pacman -Syu --needed --noconfirm nano vi gvim gedit gedit-plugins

# programming packages
arch-chroot /mnt pacman -Syu --needed --noconfirm jdk8-openjdk r swi-prolog qtcreator qt5-doc qt5-examples opencv opencv-samples lazarus-qt5 jdk-openjdk dotnet-sdk intellij-idea-community-edition pycharm-community-edition valgrind tk dia plantuml umbrello

# tools
arch-chroot /mnt pacman -Syu --needed --noconfirm wget youtube-dl expect cdrtools mc pacman-contrib fuseiso efitools sbsigntools hdparm keepassxc krusader gprename pdftk

# remote desktop
arch-chroot /mnt pacman -Syu --needed --noconfirm remmina libvncserver freerdp

# office and learning
arch-chroot /mnt pacman -Syu --needed --noconfirm librecad qcad lilypond gnucash octave gimp inkscape klavaro geogebra freemind irssi hexchat sweethome3d texstudio stellarium

# multimedia
arch-chroot /mnt pacman -Syu --needed --noconfirm audacity aegisub kid3 kodi digikam rhythmbox gst-libav blender shotcut openshot handbrake handbrake-cli mkvtoolnix-gui pencil2d

# games
arch-chroot /mnt pacman -Syu --needed --noconfirm supertuxkart wesnoth minetest minetest-server teeworlds kbounce steam steam-native-runtime widelands 0ad hedgewars openra supertux discord

# wine
arch-chroot /mnt pacman -Syu --needed --noconfirm wine-staging lutris playonlinux giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs winetricks
