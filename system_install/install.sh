#!/bin/bash

set -e

current_dir=$(dirname $0)
newusername=
desktop_environment=

. $current_dir/install_base_system.sh
. $current_dir/install_core_packages.sh intel $newusername in_chroot
. $current_dir/install_desktop_environment $desktop_environment in_chroot
