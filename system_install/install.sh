#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_base_system.sh
$current_dir/install_packages.sh
