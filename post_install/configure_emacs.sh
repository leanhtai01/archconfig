#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

mkdir -p /home/$(whoami)/emacs_backup_files
cp $parent_dir/data/BAK.emacs /home/$(whoami)/.emacs
sudo cp $parent_dir/data/BAK.emacs /root/.emacs
