#!/bin/bash

set -e

current_dir=$(dirname $0)

if [ $2 = "GNOME" ]
then
    $current_dir/configure_gnome.sh $1
    $current_dir/configure_gnome_custom_theme.sh
    # $current_dir/set_gnome_themes.sh
    $current_dir/configure_fish_shell.sh
    $current_dir/configure_gedit.sh
    $current_dir/make_shortcuts_gnome.sh
    $current_dir/configure_quadrapassel.sh
fi

if [ $2 = "KDEPlasma" ]
then
    $current_dir/configure_xsettingsd.sh
fi

$current_dir/configure_pipewire.sh
$current_dir/configure_editor.sh $(whoami)
$current_dir/configure_git.sh
$current_dir/configure_clamav.sh
