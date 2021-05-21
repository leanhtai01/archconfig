#!/bin/bash

set -e

# variables
boot_partnum=5
luks_partnum=6
parent_dir=$(cd $(dirname $0)/..; pwd)

arch-chroot /mnt pacman -Syu --needed --noconfirm grub grub-customizer

# create keyfile for encrypted boot partition (LVM on LUKS)
re="[25]"
if [[ "$user_choice" =~ $re ]] && [ $bootloader = 2 ]
then
    mkdir -m 700 /mnt/etc/luks-keys
    dd if=/dev/random of=/mnt/etc/luks-keys/cryptboot.key bs=1 count=256 status=progress
fi

cryptlvmuuidvalue=
case $user_choice in
    2) # lvm on luks
	case $bootloader in
	    2) # GRUB (encrypted boot)
		cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}3)
		printf "$bootpass1" | cryptsetup luksAddKey /dev/${install_dev}${part}2 /mnt/etc/luks-keys/cryptboot.key -
		printf "cryptboot    /dev/${install_dev}${part}2    /etc/luks-keys/cryptboot.key\n" >> /mnt/etc/crypttab
		;;
	    3) # GRUB (non-encrypted boot)
		cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}3)
		;;
	esac
	;;
    5) # dual-boot with Windows 10 (LVM on LUKS)
	case $bootloader in
	    2) # GRUB (encrypted boot)
		cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}${luks_partnum})
		printf "$bootpass1" | cryptsetup luksAddKey /dev/${install_dev}${part}${boot_partnum} /mnt/etc/luks-keys/cryptboot.key -
		printf "cryptboot    /dev/${install_dev}${part}${boot_partnum}    /etc/luks-keys/cryptboot.key\n" >> /mnt/etc/crypttab
		;;
	    3) # GRUB (non-encrypted boot)
		cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}${luks_partnum})
		;;
	esac
	;;
esac

# configure GRUB for LVM on LUKS
re="[25]"
if [[ "$user_choice" =~ $re ]]
then
    sed -i "/^GRUB_CMDLINE_LINUX=\"\"/s/\"\"/\"cryptdevice=UUID=${cryptlvmuuidvalue}:cryptlvm root=\/dev\/sys_vol_group\/root rw\"/" /mnt/etc/default/grub
    if [ $bootloader = 2 ]
    then
	sed -i "/^#GRUB_ENABLE_CRYPTODISK=y/s/^#//" /mnt/etc/default/grub
    fi
fi

# configure hibernate
if [[ "$user_choice" =~ [25] ]]
then
    sed -i "/^GRUB_CMDLINE_LINUX=/s/rw/resume=UUID=${swapuuidvalue} &/" /mnt/etc/default/grub
elif [[ "$user_choice" =~ [4] ]]
then
    sed -i "/^GRUB_CMDLINE_LINUX=\"\"/s/\"\"/\"resume=UUID=${swapuuidvalue}\"/" /mnt/etc/default/grub
fi

arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Arch Linux" --recheck
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# configure GRUB background image
mkdir /mnt/boot/grub/background
cp $parent_dir/data/grubimage.png /mnt/boot/grub/background
sed -i "/^#GRUB_BACKGROUND=/s/^#//" /mnt/etc/default/grub
sed -i "/^GRUB_BACKGROUND=/s/\".*\"/\"\/boot\/grub\/background\/grubimage.png\"/" /mnt/etc/default/grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
