#!/bin/bash

set -e

arch-chroot /mnt pacman -Syu --needed --noconfirm grub
case $user_choice in
    1) # normal install
	arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=archlinux
	grub-mkconfig -o /boot/grub/grub.cfg
	;;
esac
