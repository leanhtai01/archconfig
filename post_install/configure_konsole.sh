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
$install_command konsole

mkdir -p ~/.config

printf "MenuBar=Disabled\n" >> ~/.config/konsolerc
printf "StatusBar=Disabled\n" >> ~/.config/konsolerc
printf "\n[KonsoleWindow]\nShowMenuBarByDefault=false\n" >> ~/.config/konsolerc

