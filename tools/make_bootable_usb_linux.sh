#!/bin/bash

set -e

path_to_iso=
device=

lsblk
read -e -p "Enter USB device (sda, sdb, sdX,...): " device
read -e -p "Enter path to the iso: " path_to_iso

sudo wipefs -a /dev/$device
sudo sgdisk -Z /dev/$device
sudo sgdisk -n 0:0:0 /dev/$device
sudo dd if=$path_to_iso of=/dev/$device bs=4M conv=sync
sleep 30
lsblk
udisksctl power-off -b /dev/$device
lsblk
printf "Success!\n"
