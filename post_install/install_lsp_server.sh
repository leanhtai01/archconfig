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
$install_command npm go

go get github.com/lighttiger2505/sqls
sudo npm i intelephense -g
$install_command bash-language-server
$install_command vscode-css-languageserver
$install_command vscode-html-languageserver
sudo npm i typescript-language-server -g
$install_command typescript
$install_command vscode-json-languageserver
