#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_birdtray.sh
# $current_dir/install_vdhcoapp.sh
$current_dir/install_zoom.sh
# $current_dir/install_skype.sh
# $current_dir/install_jetbrains-toolbox.sh
# $current_dir/install_logisim-evolution.sh
# $current_dir/install_qtspim.sh
# $current_dir/install_bna.sh
$current_dir/install_hakuneko.sh
