#!/bin/bash

set -e

arch-chroot /mnt pacman -Syu --needed --noconfirm grub

case $user_choice in
    2) # lvm on luks
	cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}3)
        sed -i "/^GRUB_CMDLINE_LINUX=\"\"/s/\"\"/\"cryptdevice=UUID=${cryptlvmuuidvalue}:cryptlvm root=\/dev\/sys_vol_group\/root rw\"/" /mnt/etc/default/grub
	sed -i "/^#GRUB_ENABLE_CRYPTODISK=y/s/^#//" /mnt/etc/default/grub
	sed -i "/^GRUB_CMDLINE_LINUX=\"\"/s/rw/resume=UUID=${swapuuidvalue} &/" /mnt/etc/default/grub
	;;
esac

arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=archlinux
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
