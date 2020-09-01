#!/bin/bash

set -e

path_to_iso=
path_to_hash=
device=

lsblk
read -e -p "Enter USB device (sda, sdb, sdX,...): " device
read -e -p "Enter path to the iso: " path_to_iso
read -e -p "Enter path to hash file: " path_to_hash
sha1sum -c path_to_hash

sudo dd if=/dev/zero of=/dev/$device bs=4M count=1
sudo parted /dev/$device mklabel gpt
sudo sgdisk -Z /dev/$device
sudo sgdisk -n 0:0:0 /dev/$device
sudo mkfs.fat -F32 /dev/${device}1 -n "WINDOWS10"
sudo mkdir win_img tmp bootable_usb
sudo mount path_to_iso win_img -o loop
sudo cp -r win_img/* tmp/
sudo wimplit tmp/sources/install.wim tmp/sources/install.swm 2500
sudo rm tmp/sources/install.wim
sudo mount /dev/${device}1 bootable_usb
sudo cp -r tmp/* bootable_usb/
sudo umount bootable_usb/ win_img/
sudo rm -r tmp/ win_img/ bootable_usb/
udisksctl power-off -b /dev/$device
