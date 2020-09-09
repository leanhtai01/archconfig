#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

if ! [ -d ~/.icons ]
then
    mkdir ~/.icons
fi

tar -C ~/.icons -xvf $parent_dir/data/ArchCursorTheme.tar.gz
