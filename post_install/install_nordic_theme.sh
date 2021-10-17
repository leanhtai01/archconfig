#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

if ! [ -d ~/.local/share/icons ]
then
    mkdir ~/.local/share/icons
fi

if ! [ -d ~/.themes ]
then
    mkdir ~/.themes
fi

for file in $parent_dir/data/nordic-theme/*.tar.xz
do
    tar -C ~/.themes -xvf "$file"
done

tar -C ~/.local/share/icons -xvf $parent_dir/data/Nordic-Folders.tar.xz
mv ~/.local/share/icons/Nordic-Folders/* ~/.local/share/icons/
rm -r ~/.local/share/icons/Nordic
rmdir ~/.local/share/icons/Nordic-Folders
