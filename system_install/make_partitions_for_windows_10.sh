#!/bin/bash

set -e

# global variables
install_dev=
part=
size_of_ram=

# partition the disk
sgdisk -Z /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:2700 -c 0:"win_re" /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:ef00 -c 0:"efi" /dev/$install_dev
sgdisk -n 0:0:+1G -t 0:0c01 -c 0:"ms_reserved" /dev/$install_dev
