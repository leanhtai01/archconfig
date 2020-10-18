#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

# swap left ctrl - capslock
cp $parent_dir/data/tiling_window_manager/BAK.Xmodmap ~/.Xmodmap
