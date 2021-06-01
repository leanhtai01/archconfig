#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_azure_data_studio.sh
$current_dir/install_dislocker.sh
$current_dir/install_gdown.sh
# $current_dir/install_genymotion.sh
$current_dir/install_logisim-evolution.sh
$current_dir/install_mssql.sh
$current_dir/install_nautilus_dropbox.sh
$current_dir/install_packettracer.sh
$current_dir/install_qtspim.sh
$current_dir/install_skype.sh
$current_dir/install_teamviewer.sh
$current_dir/install_jetbrains-toolbox.sh
