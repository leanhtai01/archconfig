#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

mkdir -p /home/$(whoami)/backup_files_emacs
mkdir -p /home/$(whoami)/desktop_saves_emacs
cp -r $parent_dir/data/emacs_backup/.emacs $parent_dir/data/emacs_backup/.emacs.d /home/$(whoami)/
sudo cp -r $parent_dir/data/emacs_backup/.emacs $parent_dir/data/emacs_backup/.emacs.d /root/
