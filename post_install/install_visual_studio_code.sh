#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm gnome-keyring
yay -Syu --noconfirm visual-studio-code-bin
sudo pacman -Syu --needed --noconfirm mono-msbuild
