#!/bin/bash

set -e

sudo pacman -Syu --noconfirm cdemu-client vhba-module-dkms
sudo modprobe -a sg sr_mod vhba
# yay -Syu --noconfirm gcdemu
