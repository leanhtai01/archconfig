#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm ufw gufw
sudo systemctl enable ufw
sudo ufw enable
