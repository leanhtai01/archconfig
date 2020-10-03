#!/bin/bash

set -e

path_to_iso=
device=

lsblk
read -e -p "Enter USB device (sda, sdb, sdX,...): " device
read -e -p "Enter path to the iso: " path_to_iso

# format device
sudo wipefs -a /dev/$device
sudo sgdisk -Z /dev/$device
sudo sgdisk -n 0:0:0 /dev/$device
sudo mkfs.fat -F32 /dev/${device}1 -n "WINDOWS10"

# mount the iso
sudo mkdir win_img tmp bootable_usb
sudo mount $path_to_iso win_img -o loop
sudo cp -r win_img/* tmp/
sudo chmod -R ugo+xrw tmp/*

# split install.wim to fit fat32 filesystem
sudo wimsplit tmp/sources/install.wim tmp/sources/install.swm 2500
sudo rm tmp/sources/install.wim

# let user choose version of Windows 10 on install
sudo printf "[Channel]\r\nRetail\r\n" > tmp/sources/ei.cfg

# copy install files to usb
sudo mount /dev/${device}1 bootable_usb
sudo cp -r tmp/* bootable_usb/
sudo umount bootable_usb/ win_img/
sudo rm -r tmp/ win_img/ bootable_usb/
udisksctl power-off -b /dev/$device
