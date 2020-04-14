#!/bin/bash

# exit script immediately on error
set -e

# global variables
install_dev=
part=
size_of_ram=
rootpass1=
rootpass2=
userpass1=
userpass2=
newusername=
realname=

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

# update the system clock
timedatectl set-ntp true

# partition the disks
# dd if=/dev/zero of=/dev/sda bs=512 count=1
# parted /dev/sda mklabel gpt
dd if=/dev/zero of=/dev/$install_dev bs=512 count=1
parted /dev/$install_dev mklabel gpt
parted /dev/$install_dev mkpart efi fat32 0% 1GiB
parted /dev/$install_dev set 1 esp on
parted /dev/$install_dev mkpart swap linux-swap 1GiB $((size_of_ram+1))GiB
parted /dev/$install_dev mkpart root ext4 $((size_of_ram+1))GiB 100%

# format the partitions
dd if=/dev/zero of=/dev/${install_dev}${part}1 bs=1M count=1
dd if=/dev/zero of=/dev/${install_dev}${part}2 bs=1M count=1
dd if=/dev/zero of=/dev/${install_dev}${part}3 bs=1M count=1
mkfs.fat -F32 /dev/${install_dev}${part}1
mkswap /dev/${install_dev}${part}2
swapon /dev/${install_dev}${part}2
mkfs.ext4 /dev/${install_dev}${part}3

# mount the file systems
mount /dev/${install_dev}${part}3 /mnt
mkdir /mnt/boot
mount /dev/${install_dev}${part}1 /mnt/boot

# select the mirrors
linum=$(sed -n '/^Server = http:\/\/f.archlinuxvn.org\/archlinux\/\$repo\/os\/\$arch$/=' /etc/pacman.d/mirrorlist) # find a line and get line number
preferredmirror=$(sed -n "$linum"p /etc/pacman.d/mirrorlist) # get line know line number
sed -i '6 a ## My preferred mirrors' /etc/pacman.d/mirrorlist # insert line after
sed -i "7 a $preferredmirror" /etc/pacman.d/mirrorlist

# install essential packages
pacstrap /mnt base base-devel linux linux-headers linux-firmware

# CONFIGURE THE SYSTEM
# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# time zone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
arch-chroot /mnt hwclock --systohc

# localization
linum=$(arch-chroot /mnt sed -n '/^#en_US.UTF-8 UTF-8  $/=' /etc/locale.gen)
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/locale.gen
arch-chroot /mnt locale-gen
echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf

# configure respositories for 64-bit system
linum=$(arch-chroot /mnt sed -n "/\\[multilib\\]/=" /etc/pacman.conf)
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/pacman.conf
((linum++))
arch-chroot /mnt sed -i "${linum}s/^#//" /etc/pacman.conf

# network configuration
echo archlinux > /mnt/etc/hostname
echo "127.0.0.1    localhost" >> /mnt/etc/hosts
echo "::1          localhost" >> /mnt/etc/hosts
echo "127.0.1.1    archlinux.localdomain    archlinux" >> /mnt/etc/hosts
arch-chroot /mnt pacman -Syu --needed --noconfirm networkmanager
arch-chroot /mnt systemctl enable NetworkManager

# root password
echo -e "${rootpass1}\n${rootpass1}" | arch-chroot /mnt passwd

# add new user
arch-chroot /mnt useradd -G wheel,audio,lp,optical,storage,video,power -s /bin/bash -m $newusername -d /home/$newusername -c "$realname"
echo -e "${userpass1}\n${userpass1}" | arch-chroot /mnt passwd $newusername

# allow user in wheel group execute any command
linum=$(arch-chroot /mnt sed -n "/^# %wheel ALL=(ALL) ALL$/=" /etc/sudoers)
arch-chroot /mnt sed -i "${linum}s/^# //" /etc/sudoers # uncomment line

# configure the bootloader
arch-chroot /mnt pacman -Syu --noconfirm && arch-chroot /mnt pacman -S --needed --noconfirm efibootmgr intel-ucode
arch-chroot /mnt bootctl install
echo "default archlinux" > /mnt/boot/loader/loader.conf
echo "timeout 5" >> /mnt/boot/loader/loader.conf
echo "console-mode keep" >> /mnt/boot/loader/loader.conf
echo "editor no" >> /mnt/boot/loader/loader.conf

echo "title Arch Linux" > /mnt/boot/loader/entries/archlinux.conf
echo "linux /vmlinuz-linux" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /intel-ucode.img" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/archlinux.conf
rootuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}3)
echo "options root=UUID=${rootuuidvalue} rw" >> /mnt/boot/loader/entries/archlinux.conf

# setup hibernation
linum=$(arch-chroot /mnt sed -n '/^HOOKS=.*filesystems.*/=' /etc/mkinitcpio.conf)
arch-chroot /mnt sed -i "${linum}s/filesystems/& resume/" /etc/mkinitcpio.conf
arch-chroot /mnt mkinitcpio -p linux
swapuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}2)
echo "options resume=UUID=${swapuuidvalue}" >> /mnt/boot/loader/entries/archlinux.conf
