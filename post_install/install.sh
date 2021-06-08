#!/bin/bash

set -e

current_dir=$(dirname $0)
install_type=core # {core full virtualbox}

$current_dir/configure.sh $install_type
$current_dir/install_packages.sh $install_type
$current_dir/install_external_packages.sh $install_type

if [ $install_type = "full" ]
then
    $current_dir/install_optional_external_packages.sh
fi

