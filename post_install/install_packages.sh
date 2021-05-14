#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/configure_kvm.sh
$current_dir/install_lamp_stack.sh
$current_dir/setup_tomcat.sh
$current_dir/configure_tlp.sh
$current_dir/configure_ufw.sh
$current_dir/configure_clamav.sh
