#!/bin/bash

set -e

wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
tar -xvf yay.tar.gz
cd yay/
makepkg -sri
cd ..
rm -r yay/ yay.tar.gz
