#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_yay.sh

if [ $3 = "y" ]
then
    $current_dir/configure_java_environment.sh
fi

$current_dir/install_ibus-bamboo.sh $2
$current_dir/install_flatpak_apps.sh
$current_dir/install_google-chrome.sh
$current_dir/install_chrome-gnome-shell.sh

if [ $1 != "virtualbox" ]
then
    $current_dir/install_cdemu.sh
    $current_dir/install_ventoy-bin.sh
fi
