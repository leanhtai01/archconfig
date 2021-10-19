#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)
cp $parent_dir/data/preferredmirrors /etc/pacman.d/mirrorlist
