#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm ufw ufw-extras

if [ $1 = "GNOME" ]
then
    sudo pacman -Syu --needed --noconfirm gufw
fi

sudo systemctl enable ufw
sudo ufw enable
