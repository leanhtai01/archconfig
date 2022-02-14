#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_yay.sh

if [ $3 = "y" ]
then
    $current_dir/configure_java_environment.sh
fi

# $current_dir/install_virtualbox-ext-oracle.sh
$current_dir/install_ibus-bamboo.sh $2
$current_dir/install_visual_studio_code.sh
$current_dir/install_flatpak_apps.sh
# $current_dir/install_google-chrome.sh
# $current_dir/install_gnome-shell-extensions.sh
$current_dir/install_chrome-gnome-shell.sh
# $current_dir/install_gdown.sh
# $current_dir/install_packettracer.sh
# $current_dir/install_nautilus_dropbox.sh
# $current_dir/install_minecraft.sh

if [ $1 != "virtualbox" ]
then
    $current_dir/install_cdemu.sh
    $current_dir/install_ventoy-bin.sh
fi

# $current_dir/install_sublime_tools.sh
# $current_dir/install_dislocker.sh
# $current_dir/install_mssql.sh
# $current_dir/install_azure_data_studio.sh
# $current_dir/install_heroku.sh
