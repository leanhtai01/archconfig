#!/bin/bash

set -e

path_to_iso=
path_to_dev=

lsblk
read -e -p "Enter path to device: " path_to_dev
read -e -p "Enter path to the iso: " path_to_iso
gpg ${path_to_iso}.sig

sudo dd if=/dev/zero of=$path_to_dev bs=4M count=1
sudo sgdisk -Z $path_to_dev
sudo sgdisk -n 0:0:0 $path_to_dev
sudo dd if=$path_to_iso of=$path_to_dev bs=4M && sync
udisksctl power-off -b $path_to_dev
