#!/bin/bash

set -e

install_command="yay -Syu --needed --noconfirm"
current_dir=$(dirname $0)

$install_command gnome-shell-extension-appindicator-git gnome-shell-extension-vitals-git
$current_dir/install_switcher_gnome_shell_ext.sh
