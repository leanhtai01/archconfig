#!/bin/bash

set -e

sudo systemctl enable cdemu-daemon
sudo modprobe -a sg sr_mod vhba
yay -Syu --noconfirm gcdemu
