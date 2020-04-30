#!/bin/bash

set -e

# create place to save original config files before modified
original_config_files_path=original_config_files
mkdir $original_config_files_path

. ./configure_kvm.sh
. ./configure_lamp_stack.sh
./configure_tlp.sh
./configure_ufw.sh
. ./swap_caps_left_ctrl_console.sh
