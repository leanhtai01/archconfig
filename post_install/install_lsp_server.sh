#!/bin/bash

set -e

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
else
    prefix="sudo "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# install dependencies
$install_command npm

sudo npm i intelephense -g
$install_command bash-language-server
$install_command vscode-css-languageserver-bin
$install_command vscode-html-languageserver-bin
sudo npm i typescript-language-server -g
$install_command typescript
