#!/bin/bash

set -e

sudo pacman -Syu --noconfirm gnome-keyring
yay -Syu --noconfirm visual-studio-code-bin
sudo pacman -Syu --noconfirm mono-msbuild
