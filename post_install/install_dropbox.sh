#!/bin/bash

set -e

gpg --keyserver keys.gnupg.net --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
yay -Syu --noconfirm dropbox

# remove unused dependencies
pacman -Qdtq | sudo pacman --noconfirm -Rs -
