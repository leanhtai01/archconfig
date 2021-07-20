#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm os-prober

linum=$(sed -n $= /etc/default/grub) # get the last line number
sudo sed -i ''"${linum}"' a \\n# Detect other operating system\nGRUB_DISABLE_OS_PROBER=false' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
