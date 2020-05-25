#!/bin/bash

set -e

current_dir=$(dirname $0)
parent_dir=$(cd $(dirname $0)/..; pwd)

mkdir pkg
wget -O pkg/reflector.pkg.tar.zst https://www.archlinux.org/packages/community/any/reflector/download/
pacman -U --noconfirm pkg/reflector.pkg.tar.zst
. $current_dir/get_the_best_mirrors.sh
