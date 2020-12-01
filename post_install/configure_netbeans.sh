#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)
version=$(ls /home/$(whoami)/.netbeans | head -1)

mkdir -p /home/$(whoami)/.netbeans/$version/etc
cp $parent_dir/data/netbeans.conf /home/$(whoami)/.netbeans/$version/etc/netbeans.conf
