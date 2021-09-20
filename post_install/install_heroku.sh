#!/bin/bash

set -e

yay -Syu --noconfirm heroku-cli
sudo pacman -Syu --needed --noconfirm composer
