#!/bin/bash

set -e

sudo pacman -Syu --noconfirm
flatpak update
flatpak install flathub com.albiononline.AlbionOnline -y
