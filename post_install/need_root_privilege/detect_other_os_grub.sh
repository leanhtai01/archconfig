#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm os-prober
sudo grub-mkconfig -o /boot/grub/grub.cfg
