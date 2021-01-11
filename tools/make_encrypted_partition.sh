#!/bin/bash

set -e

current_dir=$(dirname $0)
part=$1
encrypted_name=$2
storagepass1=$3
storagepass2=
suffix=
partnum=
dev=

# let user choose device
if [ -z $part ]
then
    lsblk
    echo -n "Enter partition's name (nvme0n1p1, sda1, sda2,...): "
    read part
fi

# determine suffix
if [ "${part:0:2}" != "sd" ]
then
    suffix="${part: -2:1}"
fi

# determine partnum
partnum="${part: -1:1}"

# determine device
dev=${part%"${suffix}${partnum}"}

# let user choose name for encrypted partition
if [ -z $encrypted_name ]
then
    printf "Enter a name for encrypted partition: "
    read encrypted_name
fi

# set storage's password
printf "\nSET STORAGE'S PASSWORD:\n"
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

printf "\nStorage's password set successfully!\n"

# create the LUKS encrypted container
sudo wipefs -a /dev/${part}
sudo sgdisk -t ${partnum}:8309 -c ${partnum}:"$encrypted_name" /dev/$dev
printf "$storagepass1" | sudo cryptsetup luksFormat --type luks2 /dev/${part} -

# open the container
printf "$storagepass1" | sudo cryptsetup open /dev/${part} $encrypted_name -
sudo wipefs -a /dev/mapper/$encrypted_name

# format the partition
sudo mkfs.ext4 /dev/mapper/$encrypted_name -L "$encrypted_name"

# make partition accessable by normal user
mkdir ~/mount_point
sudo mount /dev/mapper/$encrypted_name ~/mount_point
sudo chown $(whoami):$(whoami) ~/mount_point
sudo umount ~/mount_point
rm -r ~/mount_point
sudo cryptsetup close $encrypted_name
printf "Success! /dev/${part} is encrypted!\n"
