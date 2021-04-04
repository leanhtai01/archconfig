#!/bin/bash

set -e

sudo pacman -Syu --noconfirm
flatpak update
flatpak install com.belmoussaoui.Authenticator -y
