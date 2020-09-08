#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm ufw
sudo systemctl enable ufw
sudo ufw enable
