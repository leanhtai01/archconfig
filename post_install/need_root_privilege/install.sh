#!/bin/bash

set -e

current_dir=$(dirname $0)

# create place to save original config files before modified
. $current_dir/configure_kvm.sh
. $current_dir/configure_lamp_stack.sh
$current_dir/configure_tlp.sh
$current_dir/configure_ufw.sh
. $current_dir/swap_caps_left_ctrl_console.sh
