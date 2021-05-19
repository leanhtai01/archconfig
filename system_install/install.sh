#!/bin/bash

set -e

current_dir=$(dirname $0)
parent_dir=$(cd $(dirname $0)/..; pwd)
newusername=
desktop_environment=
gpu=
connect_to_wifi=

if [ -z $connect_to_wifi ]
then
    read -e -p "Do you want connect to wifi? [y/N] " connect_to_wifi
fi

if [ $connect_to_wifi = "y" ]
then
    $parent_dir/tools/connect_wifi_iwd.sh
fi

. $current_dir/install_base_system.sh
. $current_dir/install_gpu_driver.sh $gpu $newusername in_chroot
. $current_dir/install_core_packages.sh $newusername in_chroot
. $current_dir/install_desktop_environment.sh "$desktop_environment" in_chroot $newusername
. $current_dir/install_games.sh in_chroot
