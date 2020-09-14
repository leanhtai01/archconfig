#!/bin/bash

set -e

# variables
current_dir=$(dirname $0)
install_dev=
part=
storagepass1=
storagepass2=
encrypted_name=

# let user choose device to install
if [ -z $install_dev ]
then
    lsblk
    echo -n "Enter device to install: "
    read install_dev
fi

$current_dir/clean_disk.sh $install_dev

if [ $install_dev = nvme0n1 ]
then
    part=p
fi

# let user choose name for encrypted device
if [ -z $encrypted_name ]
then
    printf "Enter a name for encrypted device: "
    read encrypted_name
fi

# set storage's password
printf "\nSET STORAGE'S PASSWORD:\n"
if [ -z $storagepass1 ] || [ -z $storagepass2 ] || [ $storagepass1 != $storagepass2 ]
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

# partition the disk
sudo dd if=/dev/zero of=/dev/$install_dev bs=4M count=1
sudo sgdisk -Z /dev/$install_dev
sudo sgdisk -n 0:0:0 -t 0:8309 -c 0:"$encrypted_name" /dev/$install_dev

# create the LUKS encrypted container
sudo dd if=/dev/zero of=/dev/${install_dev}${part}1 bs=4M count=1
printf "$storagepass1" | sudo cryptsetup luksFormat --type luks2 /dev/${install_dev}${part}1 -

# open the container
printf "$storagepass1" | sudo cryptsetup open /dev/${install_dev}${part}1 $encrypted_name -

# format the partition
sudo mkfs.ext4 /dev/mapper/$encrypted_name -L "$encrypted_name"

# make partition accessable by normal user
mkdir ~/mount_point
sudo mount /dev/mapper/$encrypted_name ~/mount_point
sudo chown $(whoami):$(whoami) ~/mount_point
sudo umount ~/mount_point
rm -r ~/mount_point
sudo cryptsetup close $encrypted_name
