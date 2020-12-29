#!/bin/bash

set -e

current_dir=$(dirname $0)
newusername=
desktop_environment=
gpu=

. $current_dir/install_base_system.sh
. $current_dir/install_gpu_driver.sh $gpu $newusername in_chroot
. $current_dir/install_core_packages.sh $newusername in_chroot
. $current_dir/install_desktop_environment.sh $desktop_environment in_chroot
. $current_dir/install_wine.sh in_chroot
