#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)
partnum=1

arch-chroot /mnt pacman -Syu --needed --noconfirm efitools

case $bootloader in
    1) # systemd-boot
	arch-chroot /mnt mkdir -p /boot/EFI/systemd/ # create dir if not exist
	arch-chroot /mnt cp /usr/share/efitools/efi/KeyTool.efi /boot/EFI/systemd/
	arch-chroot /mnt efibootmgr --verbose --disk /dev/$install_dev --part $partnum --create --label "KeyTool" --loader /EFI/systemd/KeyTool.efi
	;;
    2) # GRUB (encrypted boot)
	;&
    3) # GRUB (non-encrypted boot)
	arch-chroot /mnt mkdir -p /boot/efi/EFI/"Arch Linux"/
	arch-chroot /mnt cp /usr/share/efitools/efi/KeyTool.efi /boot/efi/EFI/"Arch Linux"/
	arch-chroot /mnt efibootmgr --verbose --disk /dev/$install_dev --part $partnum --create --label "KeyTool" --loader /EFI/"Arch Linux"/KeyTool.efi
	;;
esac


