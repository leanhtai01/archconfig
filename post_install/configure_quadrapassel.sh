#!/bin/bash

set -e

# make blocks rotate clockwise
gsettings set org.gnome.Quadrapassel rotate-counter-clock-wise false

# show where the block will land
gsettings set org.gnome.Quadrapassel show-shadow true

# set width, height
gsettings set org.gnome.Quadrapassel window-width 921
gsettings set org.gnome.Quadrapassel window-height 843
