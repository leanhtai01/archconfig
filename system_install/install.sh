#!/bin/bash

set -e

current_dir=$(dirname $0)
newusername=

. $current_dir/install_base_system.sh
. $current_dir/install_core_packages.sh $newusername
