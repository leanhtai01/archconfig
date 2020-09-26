#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_yay.sh
$current_dir/configure_ibus.sh
$current_dir/configure_kvm.sh
$current_dir/configure_lamp_stack.sh
$current_dir/configure_tlp.sh
$current_dir/configure_ufw.sh
# $current_dir/install_vmware_workstation.sh
$current_dir/install_sublime_tools.sh
$current_dir/install_visual_studio_code.sh
