#!/bin/bash

set -i

path_to_iso=$1
dest=$2

# let user choose path to iso
if [ -z $path_to_iso ]
then
    read -e -p "Enter path to the iso: " path_to_iso
fi

# let user choose where to extract iso
if [ -z $dest ]
then
    read -e -p "Enter where to extract iso: " dest
fi

# mount the iso
mkdir win_img tmp
sudo mount $path_to_iso win_img -o loop
cp -r win_img/* tmp/

# split install.wim to fit fat32 filesystem
wimsplit tmp/sources/install.wim tmp/sources/install.swm 2500
rm tmp/sources/install.wim

# let user choose version of Windows 10 on install
printf "[Channel]\r\nRetail\r\n" | sudo tee tmp/sources/ei.cfg

# copy install file to destination
cp -r tmp/* $dest
sleep 10

# remove temporary files, dirs
sudo umount win_img/
rm -r tmp/ win_img/

printf "Success!\n"


