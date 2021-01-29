#!/bin/bash

set -e

current_dir=$(dirname $0)

# $current_dir/install_arch_cursor_theme.sh
$current_dir/configure_gnome.sh
$current_dir/configure_gedit.sh
$current_dir/configure_quadrapassel.sh
$current_dir/make_shortcuts_gnome.sh
$current_dir/configure_emacs.sh
# $current_dir/swap_caps_left_ctrl_console.sh
$current_dir/configure_git.sh
$current_dir/configure_netbeans.sh
