#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

sed -i "6 r ${parent_dir}/data/preferredmirrors" /etc/pacman.d/mirrorlist
