#!/bin/bash

set -e

# install and configure some packages, services
# system packages
arch-chroot /mnt pacman -Syu --needed --noconfirm lm_sensors gparted dosfstools ntfs-3g p7zip unrar smartmontools screen psensor

# fonts
arch-chroot /mnt pacman -Syu --needed --noconfirm ttf-dejavu ttf-liberation adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts noto-fonts-emoji

# usb 3g modem
arch-chroot /mnt pacman -Syu --needed --noconfirm modemmanager usb_modeswitch wvdial
arch-chroot /mnt systemctl enable ModemManager

# audio
arch-chroot /mnt pacman -Syu --needed --noconfirm pulseaudio-alsa alsa-utils pulseaudio-bluetooth

# desktop environment
arch-chroot /mnt pacman -Syu --needed --noconfirm xorg-server xorg-xrandr lib32-vulkan-icd-loader vulkan-icd-loader vulkan-intel lib32-vulkan-intel lib32-vkd3d vkd3d xf86-video-intel lib32-mesa mesa mesa-demos

# Plasma
arch-chroot /mnt pacman -Syu --needed --noconfirm plasma digikam ktorrent ark dolphin dolphin-plugins ffmpegthumbs gwenview kalarm kamoso kate kcalc kdegraphics-mobipocket kdegraphics-thumbnailers kdf khelpcenter kleopatra kmousetool knotes kolourpaint kompare konsole krdc krfb kruler ksystemlog kwalletmanager okular spectacle sweeper umbrello gnome-disk-utility gnome-clocks krusader
arch-chroot /mnt systemctl enable sddm

# browsers
arch-chroot /mnt pacman -Syu --needed --noconfirm chromium firefox-developer-edition opera torbrowser-launcher

# editors
arch-chroot /mnt pacman -Syu --needed --noconfirm nano vi emacs gvim

# programming packages
arch-chroot /mnt pacman -Syu --needed --noconfirm gdb cmake jdk-openjdk jdk8-openjdk r swi-prolog qtcreator qt5-doc qt5-examples opencv opencv-samples git go dotnet-sdk lazarus-qt5 intellij-idea-community-edition pycharm-community-edition valgrind tk dia

# tools
arch-chroot /mnt pacman -Syu --needed --noconfirm wget youtube-dl reflector wimlib expect cdrtools mc pacman-contrib fuseiso efitools sbsigntools hdparm keepassxc transmission-qt

# remote desktop
arch-chroot /mnt pacman -Syu --needed --noconfirm remmina libvncserver freerdp

# office and learning
arch-chroot /mnt pacman -Syu --needed --noconfirm librecad qcad lilypond gnucash octave libreoffice-fresh gimp inkscape calibre klavaro kchmviewer geogebra freemind irssi hexchat thunderbird goldendict

# multimedia
arch-chroot /mnt pacman -Syu --needed --noconfirm obs-studio vlc kdenlive frei0r-plugins audacity aegisub kid3 kodi

# virtualbox
arch-chroot /mnt pacman -Syu --needed --noconfirm virtualbox virtualbox-guest-iso virtualbox-host-dkms

# wireshark
arch-chroot /mnt pacman -Syu --needed --noconfirm wireshark-qt
arch-chroot /mnt gpasswd -a leanhtai01 wireshark

# docker
arch-chroot /mnt pacman -Syu --needed --noconfirm docker
arch-chroot /mnt systemctl enable docker
arch-chroot /mnt gpasswd -a leanhtai01 docker

# games
arch-chroot /mnt pacman -Syu --needed --noconfirm supertuxkart wesnoth minetest minetest-server teeworlds kbounce kigo bovo quadrapassel steam steam-native-runtime

# wine
arch-chroot /mnt pacman -Syu --needed --noconfirm wine-staging lutris giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs

# enable bluetooth service
arch-chroot /mnt systemctl enable bluetooth
