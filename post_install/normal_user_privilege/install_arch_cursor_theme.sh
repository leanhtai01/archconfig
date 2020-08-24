#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)
grandpa_dir=$(cd $parent_dir/..; pwd)

if ! [ -d "~/.icons" ]
then
    mkdir ~/.icons
fi

tar -C ~/.icons -xvf $grandpa_dir/data/ArchCursorTheme.tar.gz
