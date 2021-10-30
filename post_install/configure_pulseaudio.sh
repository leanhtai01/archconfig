#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

mkdir -p ~/.config/pulse/
cp $parent_dir/data/daemon.conf ~/.config/pulse/
cp $parent_dir/data/asound.conf ~/.asoundrc
