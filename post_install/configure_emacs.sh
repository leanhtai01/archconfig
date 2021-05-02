#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

mkdir -p /home/$(whoami)/backup_files_emacs
mkdir -p /home/$(whoami)/desktop_saves_emacs
cp $parent_dir/data/BAK.emacs /home/$(whoami)/.emacs
sudo cp $parent_dir/data/BAK.emacs /root/.emacs
