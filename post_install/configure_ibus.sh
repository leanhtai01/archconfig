#!/bin/bash

set -e

yay -Syu --needed --noconfirm ibus-bamboo

# configure for KDE Plasma
# cat ../data/ibus_config_data > ~/.xprofile
# ibus-daemon -drx
