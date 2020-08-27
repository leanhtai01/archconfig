#!/bin/bash

set -e

# install and configure some packages, services
# system packages
arch-chroot /mnt pacman -Syu --needed --noconfirm lm_sensors gparted dosfstools ntfs-3g p7zip unrar

# fonts
arch-chroot /mnt pacman -Syu --needed --noconfirm ttf-dejavu ttf-liberation adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts noto-fonts-emoji ttf-hack

# audio
arch-chroot /mnt pacman -Syu --needed --noconfirm pulseaudio-alsa alsa-utils pulseaudio-bluetooth

# desktop environment
arch-chroot /mnt pacman -Syu --needed --noconfirm xorg-server xorg-xrandr lib32-vulkan-icd-loader vulkan-icd-loader vulkan-intel lib32-vulkan-intel lib32-vkd3d vkd3d xf86-video-intel lib32-mesa mesa mesa-demos

# GNOME
arch-chroot /mnt pacman -Syu --needed --noconfirm gnome gnome-extra seahorse seahorse-nautilus chrome-gnome-shell khelpcenter gnome-calendar
arch-chroot /mnt systemctl enable gdm  

# browsers
arch-chroot /mnt pacman -Syu --needed --noconfirm chromium

# editors
arch-chroot /mnt pacman -Syu --needed --noconfirm emacs

# programming packages
arch-chroot /mnt pacman -Syu --needed --noconfirm gdb cmake git go

# tools
arch-chroot /mnt pacman -Syu --needed --noconfirm reflector wimlib transmission-gtk gnome-clocks alacarte file-roller

# office and learning
arch-chroot /mnt pacman -Syu --needed --noconfirm libreoffice-fresh calibre kchmviewer goldendict kolourpaint

# multimedia
arch-chroot /mnt pacman -Syu --needed --noconfirm obs-studio vlc kdenlive frei0r-plugins

# virtualbox
arch-chroot /mnt pacman -Syu --needed --noconfirm virtualbox virtualbox-guest-iso virtualbox-host-dkms

# wireshark
arch-chroot /mnt pacman -Syu --needed --noconfirm wireshark-qt
arch-chroot /mnt gpasswd -a $newusername wireshark

# docker
arch-chroot /mnt pacman -Syu --needed --noconfirm docker
arch-chroot /mnt systemctl enable docker
arch-chroot /mnt gpasswd -a $newusername docker

# games
arch-chroot /mnt pacman -Syu --needed --noconfirm kigo bovo gnuchess

# enable bluetooth service
arch-chroot /mnt systemctl enable bluetooth
