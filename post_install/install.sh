#!/bin/bash

set -e

current_dir=$(dirname $0)
install_type=core # {core full}

$current_dir/configure.sh
$current_dir/install_packages.sh
$current_dir/install_external_packages.sh

if [ $install_type = "full" ]
then
    $current_dir/install_optional_external_packages.sh
fi

