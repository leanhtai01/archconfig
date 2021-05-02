#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_yay.sh
$current_dir/install_ibus-bamboo.sh
$current_dir/install_virtualbox-ext-oracle.sh
$current_dir/install_gcdemu.sh
$current_dir/install_flatpak_apps.sh
$current_dir/install_minecraft.sh
