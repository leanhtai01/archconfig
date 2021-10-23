#!/bin/bash

set -e

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
else
    prefix="sudo "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

$install_command zsh zsh-completions grml-zsh-config zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
printf "source /etc/zsh/zshrc\n" > ~/.zshrc
printf "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh\n" >> ~/.zshrc
printf "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
