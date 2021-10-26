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
sudo npm i vscode-css-languageserver-bin -g
sudo npm i vscode-html-languageserver-bin -g
sudo npm i typescript-language-server -g
sudo npm i typescript -g
