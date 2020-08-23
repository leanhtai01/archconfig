#!/bin/bash

set -e

arch-chroot /mnt pacman -Syu --needed --noconfirm grub

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
		cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}5)
		printf "$bootpass1" | cryptsetup luksAddKey /dev/${install_dev}${part}4 /mnt/etc/luks-keys/cryptboot.key -
		printf "cryptboot    /dev/${install_dev}${part}4    /etc/luks-keys/cryptboot.key\n" >> /mnt/etc/crypttab
		;;
	    3) # GRUB (non-encrypted boot)
		cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}5)
		;;
	esac
	;;
esac

# configure GRUB for LVM on LUKS
re="[25]"
if [[ "$user_choice" =~ $re ]]
then
    sed -i "/^GRUB_CMDLINE_LINUX=\"\"/s/\"\"/\"cryptdevice=UUID=${cryptlvmuuidvalue}:cryptlvm root=\/dev\/sys_vol_group\/root rw\"/" /mnt/etc/default/grub
    sed -i "/^GRUB_CMDLINE_LINUX=/s/rw/resume=UUID=${swapuuidvalue} &/" /mnt/etc/default/grub
    if [ $bootloader = 2 ]
    then
	sed -i "/^#GRUB_ENABLE_CRYPTODISK=y/s/^#//" /mnt/etc/default/grub
    fi
fi

arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Arch Linux" --recheck
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
