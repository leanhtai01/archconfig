#!/bin/bash

set -e

current_dir=$(dirname $0)
newusername=

. $current_dir/install_base_system.sh
. $current_dir/install_core_packages.sh intel $newusername in_chroot
. $current_dir/install_optional_packages.sh in_chroot
