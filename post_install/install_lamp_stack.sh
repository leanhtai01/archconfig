#!/bin/bash

set -e

current_dir=$(dirname $0)

. $current_dir/install_packages_lamp.sh
. $current_dir/configure_lamp_stack.sh
