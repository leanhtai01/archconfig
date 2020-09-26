#!/bin/bash

set -e

yay -Syu --noconfirm visual-studio-code-bin
sudo pacman -Syu --noconfirm mono-msbuild
