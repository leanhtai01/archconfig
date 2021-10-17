#!/bin/bash

set -e

current_dir=$(dirname $0)

# enable user-theme
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com']"

# install Nordic theme
$current_dir/install_nordic_theme.sh

# install GNOME Terminal Nord theme
$current_dir/install_nord_theme_gnome-terminal.sh

# install cursor theme
$current_dir/install_arch_cursor_theme.sh
