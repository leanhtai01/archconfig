#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_yay.sh
$current_dir/configure_java_environment.sh
$current_dir/install_ibus-bamboo.sh $2
$current_dir/install_flatpak_apps.sh
$current_dir/install_sublime_tools.sh
$current_dir/install_visual_studio_code.sh

if [ $2 = "GNOME" ]
then
    $current_dir/install_chrome-gnome-shell.sh
fi

if [ $1 != "virtualbox" ]
then
    $current_dir/install_virtualbox-ext-oracle.sh
    $current_dir/install_minecraft.sh
    $current_dir/install_vmware_workstation.sh
    $current_dir/install_ventoy-bin.sh
    $current_dir/install_gcdemu.sh
fi

if [ $1 = "full" ]
then
    $current_dir/install_vdhcoapp.sh
    $current_dir/install_zoom.sh
fi
