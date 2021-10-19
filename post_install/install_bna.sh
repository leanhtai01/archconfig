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
$install_command python-pip

sudo pip install bna
