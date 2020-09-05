#!/bin/bash

set -e

current_dir=$(dirname $0)
parent_dir=$(cd $(dirname $0)/..; pwd)

mkdir pkg

# curl -LJo pkg/reflector.pkg.tar.zst https://www.archlinux.org/packages/community/any/reflector/download/
curl -LJo pkg/fakeroot.pkg.tar.zst https://www.archlinux.org/packages/core/x86_64/fakeroot/download/
curl -LJo pkg/pacman-contrib.pkg.tar.zst https://www.archlinux.org/packages/community/x86_64/pacman-contrib/download/
# pacman -U --noconfirm pkg/reflector.pkg.tar.zst
pacman -U --noconfirm pkg/fakeroot.pkg.tar.zst
pacman -U --noconfirm pkg/pacman-contrib.pkg.tar.zst
. $current_dir/get_the_best_mirrors.sh
