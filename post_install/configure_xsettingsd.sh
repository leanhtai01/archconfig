#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

sudo pacman -Syu --needed --noconfirm xsettingsd
cp $parent_dir/data/xsettingsd /home/$(whoami)/.xsettingsd
