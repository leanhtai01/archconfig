#!/bin/bash

set -e

pacman -Syu --needed --noconfirm os-prober
grub-mkconfig -o /boot/grub/grub.cfg
