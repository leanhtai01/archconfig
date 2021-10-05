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
sudo npm i -g bash-language-server
sudo npm install -g vscode-css-languageserver-bin
sudo npm install -g vscode-html-languageserver-bin
