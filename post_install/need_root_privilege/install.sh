#!/bin/bash

set -e

./configure_kvm.sh
./configure_lamp_stack.sh
./configure_tlp.sh
./configure_ufw.sh
./swap_caps_left_ctrl_console.sh
