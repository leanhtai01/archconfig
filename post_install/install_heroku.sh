#!/bin/bash

set -e

yay -Syu --noconfirm heroku-cli-bin
sudo pacman -Syu --needed --noconfirm composer
