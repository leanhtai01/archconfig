#!/bin/bash

set -e

pacman -Syu --needed --noconfirm ufw
systemctl enable ufw
ufw enable
