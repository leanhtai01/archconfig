#!/bin/bash

set -e

current_dir=$(dirname $0)

if [ $2 = "GNOME" ]
then
    $current_dir/configure_gnome.sh $1
    $current_dir/configure_gedit.sh
    $current_dir/make_shortcuts_gnome.sh
fi

$current_dir/configure_emacs.sh
$current_dir/configure_git.sh

if [ $1 != "virtualbox" ]
then
    $current_dir/configure_clamav.sh
fi
