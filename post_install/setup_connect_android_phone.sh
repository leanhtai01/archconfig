#!/bin/bash

set -e

install_command="sudo pacman -Syu --needed --noconfirm"
install_command_aur="yay -Syu --needed --noconfirm"

$install_command mtpfs gvfs-mtp gvfs-gphoto2
