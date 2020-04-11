#!/bin/bash

# install and configure some packages, services
# system packages
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm lm_sensors ufw gparted dosfstools ntfs-3g p7zip unrar

# fonts
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm ttf-dejavu ttf-liberation adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts noto-fonts-emoji

# network
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm networkmanager modemmanager usb_modeswitch wvdial
arch-chroot /mnt systemctl enable NetworkManager
arch-chroot /mnt systemctl enable ModemManager

# audio
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm pulseaudio-alsa alsa-utils

# desktop environment
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm xorg-server xorg-xrandr lib32-vulkan-icd-loader vulkan-icd-loader vulkan-intel xf86-video-intel lib32-mesa mesa mesa-demos

# # GNOME
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm gnome alacarte file-roller seahorse gst-libav seahorse-nautilus gnome-clocks gnome-calendar rhythmbox gprename gnuchess transmission-gtk chrome-gnome-shell gedit gedit-plugins gnome-sound-recorder gnome-tweaks gnome-builder devhelp dconf-editor
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm gnome-extra
# arch-chroot /mnt systemctl enable gdm

# Plasma
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm plasma digikam ktorrent ark dolphin dolphin-plugins ffmpegthumbs gwenview kalarm kamoso kate kcalc kdegraphics-mobipocket kdegraphics-thumbnailers kdf khelpcenter kleopatra kmousetool knotes kolourpaint kompare konsole krdc krfb kruler ksystemlog ktimer kwalletmanager okular spectacle sweeper umbrello
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm kde-applications
arch-chroot /mnt systemctl enable sddm

# browsers
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm chromium
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm opera
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm firefox-developer-edition

# editors
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm atom
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm geany
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm nano
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm vi
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm emacs
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm gvim

# programming packages
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm gdb cmake jdk-openjdk jdk8-openjdk r swi-prolog qtcreator qt5-doc qt5-examples opencv opencv-samples git go dotnet-sdk lazarus-qt5 intellij-idea-community-edition pycharm-community-edition valgrind eclipse-java tk

# tools
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm wget youtube-dl reflector wimlib

# office and learning
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm librecad qcad lilypond gnucash octave
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm libreoffice-fresh gimp inkscape calibre klavaro goldendict kchmviewer geogebra freemind

# multimedia
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm obs-studio vlc
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm kdenlive frei0r-plugins audacity aegisub kid3 kodi

# virtualbox
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm virtualbox virtualbox-guest-iso virtualbox-host-dkms

# games
# arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm supertuxkart wesnoth minetest minetest-server teeworlds kbounce kigo bovo quadrapassel
