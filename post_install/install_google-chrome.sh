#!/bin/bash

set -e

yay -Syu --noconfirm google-chrome
sudo pacman -Syu --needed --noconfirm xdg-desktop-portal-gtk pipewire
