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
printf "\nSET ROOT'S PASSWORD\n"
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
printf "\nCREATE A NEW USER\n"

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
echo -e "\nUser $newusername created successfully!\n"

# let user choose type of install
display_menu()
{
    printf "Choose type of install:\n"
    printf "1. Normal install\n"
    printf "2. LVM on LUKS\n"
    printf "3. LUKS on LVM\n"
    printf "4. Dual-boot with Windows 10 (normal install)\n"
    printf "5. Dual-boot with Windows 10 (LVM on LUKS)\n"
    printf "6. Dual-boot with Windows 10 (LUKS on LVM)\n"
    printf "Enter your choice: "
}
    
if [ -z $user_choice ]
then
    re="[1-6]"

    display_menu
    read user_choice

    while [[ ! "$user_choice" =~ $re ]]
    do
	printf "\nInvalid choice! Please try again!\n"
	display_menu
	read user_choice
    done
fi

printf "You have chosen "
case $user_choice in
    1)
        printf "Normal install!\n"
	;;
    2)
        printf "LVM on LUKS!\n"
	;;
    3)
        printf "LUKS on LVM!\n"
	;;
    4)
        printf "dual-boot with Windows 10 (normal install)!\n"
	;;
    5)
	printf "dual-boot with Windows 10 (LVM on LUKS)!\n"
	;;
    6)
	printf "dual-boot with Windows 10 (LUKS on LVM)\n"
	;;
esac

# set storage's password if needed
re="[2356]"
if [[ "$user_choice" =~ $re ]]
then
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
fi

# let user choose boot loader to install
display_menu_bootloader()
{
    printf "Choose a boot loader to install:\n"
    printf "1. systemd-boot\n"
    printf "2. GRUB\n"
    printf "Enter your choice: "
}

if [ -z $bootloader ]
then
    re="[1-2]"

    printf "\n"
    display_menu_bootloader
    read bootloader

    while [[ ! "$bootloader" =~ $re ]]
    do
	printf "\nInvalid choice! Please try again!\n"
	display_menu_bootloader
	read bootloader
    done
fi

printf "You have chosen "
case $bootloader in
    1)
	printf "systemd-boot"
	;;
    2)
	printf "GRUB"
	;;
esac
printf " boot loader!\n"

# let user enter password for encrypted boot partition (only for GRUB)
re="[25]"
if [ $bootloader = 2 ] && [[ "$user_choice" =~ $re ]]
then
    printf "\nSET BOOT'S PASSWORD\n"
    if [ -z $bootpass1 ] || [ -z $bootpass2 ] || [ $bootpass1 != $bootpass2 ]
    then
	echo -n "Enter new boot's password: "
	read -s bootpass1
	echo -n -e "\nRetype boot's password: "
	read -s bootpass2

	while [ -z $bootpass1 ] || [ -z $bootpass2 ] || [ $bootpass1 != $bootpass2 ]
	do
	    echo -e "\nSorry, passwords do not match. Please try again!"
	    echo -n "Enter boot's password: "
	    read -s bootpass1
	    echo -n -e "\nRetype boot's password: "
	    read -s bootpass2
	done
    fi
    echo -e "\nboot's password set successfully!"
fi
