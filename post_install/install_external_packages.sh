#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_yay.sh

if [ $3 = "y" ]
then
    $current_dir/configure_java_environment.sh
fi

$current_dir/install_flatpak_apps.sh

if [ $2 = "GNOME" ]
then
    $current_dir/install_chrome-gnome-shell.sh
fi

if [ $1 != "virtualbox" ]
then
    $current_dir/install_virtualbox-ext-oracle.sh
    $current_dir/install_ventoy-bin.sh
    $current_dir/install_gcdemu.sh
fi
