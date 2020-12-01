#!/bin/bash

set -e

# open netbeans for the first time then close
current_dir=$(dirname $0)
$current_dir/open_netbeans_first_time.sh

# configure antialiasing in netbeans
parent_dir=$(cd $(dirname $0)/..; pwd)
version=$(ls /home/$(whoami)/.netbeans | head -1)

mkdir -p /home/$(whoami)/.netbeans/$version/etc
cp $parent_dir/data/netbeans.conf /home/$(whoami)/.netbeans/$version/etc/netbeans.conf
