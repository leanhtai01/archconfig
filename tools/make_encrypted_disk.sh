#!/bin/bash

set -e

current_dir=$(dirname $0)
encrypted_name=$2
storagepass1=$3
storagepass2=
suffix=
partnum=1
dev=$1

# let user choose device
if [ -z $dev ]
then
    lsblk
    echo -n "Enter device's name (sda, nvme0n1, mmcblk0,...): "
    read dev
fi

# determine suffix based on dev's name
if [ "${dev:0:2}" != "sd" ]
then
    suffix=p
fi

# let user choose name for encrypted device
if [ -z $encrypted_name ]
then
    printf "Enter a name for encrypted device: "
    read encrypted_name
fi

$current_dir/clean_disk.sh $dev

# set storage's password
if [ -z $storagepass1 ]
then
    printf "Enter storage's password: "
    read -s storagepass1
    printf "\nRetype storage's password: "
    read -s storagepass2

    while [ -z $storagepass1 ] || [ -z $storagepass2 ] || [ $storagepass1 != $storagepass2 ]
    do
	printf "\nSorry, passwords do not match. Please try again!\n"
	printf "Enter storage's password: "
	read -s storagepass1
	printf "\nRetype storage's password: "
	read -s storagepass2
    done
fi

# make a new partition on disk
sudo wipefs -a /dev/$dev
sudo sgdisk -Z /dev/$dev
sudo sgdisk -n 0:0:0 -t 0:8309 -c 0:"$encrypted_name" /dev/$dev

# encrypted the new partition
$current_dir/make_encrypted_partition.sh "${dev}${suffix}${partnum}" "$encrypted_name" "$storagepass1"

printf "Device /dev/${dev} encrypted successfully!\n"

