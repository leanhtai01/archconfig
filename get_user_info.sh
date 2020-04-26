#!/bin/bash

# exit script immediately on error
set -e

# let user choose device to install
if [ -z $install_dev ]
then
    lsblk
    echo -n "Enter device to install: "
    read install_dev
fi

if [ $install_dev = nvme0n1 ]
then
    part=p
fi

# let user enter size of RAM to determine swap's size
if [ -z $size_of_ram ]
then
    echo -n "Enter size of RAM (in GB): "
    read size_of_ram
fi

# set root's password
echo "SET ROOT'S PASSWORD"
if [ -z $rootpass1 ] || [ -z $rootpass2 ] || [ $rootpass1 != $rootpass2 ]
then
    echo -n "Enter new root's password: "
    read -s rootpass1
    echo -n -e "\nRetype root's password: "
    read -s rootpass2

    while [ -z $rootpass1 ] || [ -z $rootpass2 ] || [ $rootpass1 != $rootpass2 ]
    do
	echo -e "\nSorry, passwords do not match. Please try again!"
	echo -n "Enter root's password: "
	read -s rootpass1
	echo -n -e "\nRetype root's password: "
	read -s rootpass2
    done
fi
echo -e "\nroot's password set successfully!"

# create a new user
echo "CREATE A NEW USER"

if [ -z $newusername ]
then
    echo -n "Enter username: "
    read newusername
fi

if [ -z "$realname" ]
then
    echo -n "Enter real name: "
    read realname
fi

if [ -z $userpass1 ] || [ -z $userpass2 ] || [ $userpass1 != $userpass2 ]
then
    echo -n "Enter ${newusername}'s password: "
    read -s userpass1
    echo -n -e "\nRetype $newusername's password: "
    read -s userpass2

    while [ -z $userpass1 ] || [ -z $userpass2 ] || [ $userpass1 != $userpass2 ]
    do
	echo -e "\nSorry, passwords do not match. Please try again!"
	echo -n "Enter $newusername's password: "
	read -s userpass1
	echo -n -e "\nRetype $newusername's password: "
	read -s userpass2
    done
fi
echo -e "\nUser $newusername created successfully!"
