#!/bin/bash

set -e

wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
tar -xvf yay.tar.gz
cd yay/
makepkg -sri --noconfirm
cd ..
rm -rf yay/ yay.tar.gz
