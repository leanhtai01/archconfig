#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

sudo pacman -Syu --needed --noconfirm dnscrypt-proxy
$parent_dir/tools/enable_dnscrypt-proxy.sh
sleep 20
