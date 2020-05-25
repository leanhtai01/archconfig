#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

mkdir pkg tmp
wget -O pkg/reflector.pkg.tar.zst https://www.archlinux.org/packages/community/any/reflector/download/
pacman -U --noconfirm pkg/reflector.pkg.tar.zst
reflector --latest 10 --protocol http --protocol https --sort rate --save tmp/mirrorlist
sed -n '/^Server.*/,$p' tmp/mirrorlist > /etc/pacman.d/mirrorlist
