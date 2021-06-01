#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/configure.sh
$current_dir/install_packages.sh
$current_dir/install_external_packages.sh
$current_dir/install_optional_external_packages.sh
