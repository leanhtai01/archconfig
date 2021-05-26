#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_yay.sh
$current_dir/configure_java_environment.sh
$current_dir/install_ibus-bamboo.sh
$current_dir/install_virtualbox-ext-oracle.sh
$current_dir/install_gcdemu.sh
$current_dir/install_flatpak_apps.sh
$current_dir/install_sublime_tools.sh
$current_dir/install_minecraft.sh
$current_dir/install_azure_data_studio.sh
$current_dir/install_dislocker.sh
$current_dir/install_gdown.sh
$current_dir/install_genymotion.sh
$current_dir/install_logisim-evolution.sh
$current_dir/install_mssql.sh
$current_dir/install_nautilus_dropbox.sh
$current_dir/install_packettracer.sh
$current_dir/install_qtspim.sh
$current_dir/install_skype.sh
$current_dir/install_teamviewer.sh
$current_dir/install_visual_studio_code.sh
$current_dir/install_zoom.sh
$current_dir/install_vmware_workstation.sh
$current_dir/install_chrome-gnome-shell.sh
$current_dir/install_jetbrains-toolbox.sh
$current_dir/install_ventoy-bin.sh
$current_dir/install_vdhcoapp.sh
