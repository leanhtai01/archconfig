#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm ufw gufw ufw-extras
sudo systemctl enable ufw
# sudo ufw enable
