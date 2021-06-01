#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/configure_gnome.sh
$current_dir/configure_gedit.sh
$current_dir/make_shortcuts_gnome.sh
$current_dir/configure_emacs.sh
$current_dir/configure_git.sh
$current_dir/configure_clamav.sh
