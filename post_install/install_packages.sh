#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_yay.sh
$current_dir/configure_ibus.sh
$current_dir/configure_kvm.sh
$current_dir/install_lamp_stack.sh
$current_dir/configure_tlp.sh
$current_dir/configure_ufw.sh
# $current_dir/install_vmware_workstation.sh
# $current_dir/install_sublime_tools.sh
# $current_dir/install_mssql.sh
# $current_dir/install_visual_studio_code.sh
# $current_dir/install_azure_data_studio.sh
# $current_dir/install_dropbox.sh
$current_dir/install_nautilus_dropbox.sh
$current_dir/install_usb_wifi_driver.sh
# $current_dir/install_virtualbox-ext-oracle.sh
# $current_dir/install_zoom.sh
# $current_dir/install_roslynpad.sh
# $current_dir/install_dislocker.sh
$current_dir/install_minecraft.sh
# $current_dir/install_poweriso.sh
