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
    printf "2. GRUB (encrypted boot)\n"
    printf "3. GRUB (non-encrypted boot)\n"
    printf "Enter your choice: "
}

if [ -z $bootloader ]
then
    re="[1-3]"

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
	printf "GRUB (encrypted boot)"
	;;
    3)
	printf "GRUB (non-encrypted boot)"
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
    echo -e "\nboot's password set successfully!\n"
fi

# ask user for setup secure boot
if [ -z $setupsecureboot ]
then
    printf "\nDo you want setup secure boot? [y/N] "
    read setupsecureboot
fi

re="[yY]"
if ! [[ "$setupsecureboot" =~ $re ]]
then
    setupsecureboot="n"
    printf "Secure boot won't be setup!\n\n"
else
    setupsecureboot="y"
    printf "Ok! Secure boot will be setup!\n\n"
fi

# ask user for setup KeyTool
if [ -z $setupkeytool ]
then
    printf "Do you want setup KeyTool? [y/N] "
    read setupkeytool
fi

re="[yY]"
if ! [[ "$setupkeytool" =~ $re ]]
then
    setupkeytool="n"
    printf "KeyTool won't be setup!\n\n"
else
    setupkeytool="y"
    printf "Ok! KeyTool will be setup!\n\n"
fi

# ask user for setup desktop environment
display_menu_desktop_environment()
{
    printf "Choose desktop environment:\n"
    printf "1. GNOME\n"
    printf "2. KDE Plasma\n"
    printf "3. i3 (tiling window manager)\n"
    printf "4. None\n"
    printf "Enter your choice: "
}

if [ -z "$desktop_environment" ]
then
    re="[1-4]"

    display_menu_desktop_environment
    read DE_choice

    while [[ ! "$DE_choice" =~ $re ]]
    do
	printf "\nInvalid choice! Please try again!\n"
	display_menu_desktop_environment
	read DE_choice
    done

    # set desktop enviroment will be installed
    case $DE_choice in
	1)
	    desktop_environment=GNOME
	    ;;
	2)
	    desktop_environment=KDEPlasma
	    ;;
	3)
	    desktop_environment=i3
	    ;;
	4)
	    desktop_environment=none
	    ;;
    esac
fi

printf "${desktop_environment} will be installed!\n\n"

# ask user for gpu driver
display_menu_gpu_driver()
{
    printf "Choose your gpu driver:\n"
    printf "1. Intel\n"
    printf "2. VirtualBox\n"
    printf "3. None\n"
    printf "Enter your choice: "
}

if [ -z "$gpu" ]
then
    re="[1-3]"

    display_menu_gpu_driver
    read gpu_driver_choice

    while [[ ! "$gpu_driver_choice" =~ $re ]]
    do
	printf "\nInvalid choice! Please try again!\n"
	display_menu_gpu_driver
	read gpu_driver_choice
    done

    # set gpu driver will be installed
    case $gpu_driver_choice in
	1)
	    gpu=intel
	    ;;
	2)
	    gpu=virtualbox
	    ;;
    esac
fi

printf "${gpu} driver will be installed!\n\n"

# ask for hostname
if [ -z $hostname ]
then
    printf "Enter hostname: "
    read hostname
fi

# ask for way to setup mirrors
if [ -z "$simple_setup_mirror" ]
then
    read -e -p "Do you want using simple setup mirror? [y/N] " simple_setup_mirror
fi

# ask user whether in pipewire audio server
if [ -z "$install_pipewire_audio_server" ]
then
    read -e -p "Do you want install pipewire audio server? [y/N] " install_pipewire_audio_server
fi
