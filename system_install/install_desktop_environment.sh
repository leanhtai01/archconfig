#!/bin/bash

set -e

current_dir=$(dirname $0)

case $1 in
    GNOME)
	. $current_dir/install_GNOME.sh $2
	;;
    i3)
	. $current_dir/install_i3wm.sh $2
esac
