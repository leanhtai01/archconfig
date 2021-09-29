#!/bin/bash

set -e

path_to_iso=$1
dest=$2
is_split_wim=$3

# let user choose path to iso
if [ -z $path_to_iso ]
then
    read -e -p "Enter path to the iso: " path_to_iso
fi

# get full path to file iso
full_path=$(readlink -f "$path_to_iso")

# get the name of file iso
tmp=$(printf "$full_path" | rev | cut -d'/' -f1 | rev)
iso_name=$(printf "${tmp:0:-4}")
file_name="${iso_name}_modified.iso"

# mount the iso
mkdir win_img
sudo mount $path_to_iso win_img -o loop

# create dir for modifications
mkdir -p modified/sources

# let user choose version of Windows on install
printf "[Channel]\r\nRetail\r\n" | sudo tee modified/sources/ei.cfg

# create custom iso
mkisofs \
    -iso-level 4 \
    -l \
    -R \
    -UDF \
    -D \
    -b boot/etfsboot.com \
    -no-emul-boot \
    -boot-load-size 8 \
    -hide boot.catalog \
    -eltorito-alt-boot \
    -eltorito-platform efi \
    -no-emul-boot \
    -b efi/microsoft/boot/efisys.bin \
    -o $file_name \
    win_img/ modified/

# remove temporary files, dirs
sudo umount win_img/
sudo rm -r win_img/ modified $path_to_iso

printf "Success making custom Windows iso!\n"

