#!/bin/bash

set -e

current_dir=$(dirname $0)

if [ $2 = "GNOME" ]
then
    $current_dir/configure_gnome.sh $1
    # $current_dir/configure_gnome_custom_theme.sh
    $current_dir/install_nord_theme_gnome-terminal.sh
    $current_dir/set_gnome_themes.sh
    # $current_dir/configure_fish_shell.sh
    $current_dir/configure_zsh.sh
    # $current_dir/configure_konsole.sh
    # $current_dir/configure_gedit.sh
    $current_dir/make_shortcuts_gnome.sh
    # $current_dir/configure_quadrapassel.sh
fi

if [ $2 = "KDEPlasma" ]
then
    $current_dir/configure_xsettingsd.sh
fi

# configure sound server
if pacman -Qi pipewire-pulse > /dev/null
then
    $current_dir/configure_pipewire.sh
else
    $current_dir/configure_pulseaudio.sh
fi

$current_dir/configure_editor.sh $(whoami)
$current_dir/configure_git.sh
$current_dir/configure_clamav.sh
