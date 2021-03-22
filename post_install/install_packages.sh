#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_yay.sh
$current_dir/install_ibus-bamboo.sh
$current_dir/configure_kvm.sh
$current_dir/install_lamp_stack.sh
$current_dir/configure_tlp.sh
$current_dir/configure_ufw.sh
$current_dir/install_sublime_tools.sh
$current_dir/install_virtualbox-ext-oracle.sh
$current_dir/install_gcdemu.sh
