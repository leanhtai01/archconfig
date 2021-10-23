#!/bin/bash

set -e

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
else
    prefix="sudo "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

$install_command zsh zsh-completions grml-zsh-config
printf "source /etc/zsh/zshrc\n" > ~/.zshrc
