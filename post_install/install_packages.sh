#!/bin/bash

set -e

current_dir=$(dirname $0)

if [ $1 != "virtualbox" ]
then
    $current_dir/configure_kvm.sh
    $current_dir/configure_tlp.sh
fi

$current_dir/install_lamp_stack.sh
$current_dir/configure_ufw.sh $2
