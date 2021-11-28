#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)
partnum=1

arch-chroot /mnt pacman -Syu --needed --noconfirm efitools

case $bootloader in
    1) # systemd-boot
        cp $parent_dir/data/preloader-signed/{PreLoader,HashTool}.efi /mnt/efi/EFI/systemd
        cp /mnt/efi/EFI/systemd/systemd-bootx64.efi /mnt/efi/EFI/systemd/loader.efi
	arch-chroot /mnt efibootmgr --verbose --disk /dev/$install_dev --part $partnum --create --label "Arch Linux SB" --loader /EFI/systemd/PreLoader.efi
	;;
    2) # GRUB (encrypted boot)
	;&
    3) # GRUB (non-encrypted boot)
        cp $parent_dir/data/preloader-signed/{PreLoader,HashTool}.efi /mnt/boot/efi/EFI/"Arch Linux"
        cp /mnt/boot/efi/EFI/"Arch Linux"/grubx64.efi /mnt/boot/efi/EFI/"Arch Linux"/loader.efi
	arch-chroot /mnt efibootmgr --verbose --disk /dev/$install_dev --part $partnum --create --label "Arch Linux SB" --loader /EFI/"Arch Linux"/PreLoader.efi
	;;
esac


