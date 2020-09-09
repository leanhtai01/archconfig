#!/bin/bash

set -e

sudo pacman -Syu
curl -LJo yay.tar.gz https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
tar -xvf yay.tar.gz
cd yay/
makepkg -sri --noconfirm
cd ..
rm -rf yay/ yay.tar.gz
