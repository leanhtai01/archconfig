#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)
partnum=2

re="[123]"
if [[ "$user_choice" =~ $re ]]
then
    partnum=1
fi

case $bootloader in
    1) # systemd-boot
	arch-chroot /mnt cp $parent_dir/data/preloader-signed/{PreLoader,HashTool}.efi /boot/EFI/systemd
	arch-chroot /mnt cp /boot/EFI/systemd/systemd-bootx64.efi /boot/EFI/systemd/loader.efi
	arch-chroot /mnt efibootmgr --verbose --disk /dev/$install_dev --part $partnum --create --label "archlinuxsecure" --loader /EFI/systemd/PreLoader.efi
	;;
    2) # GRUB (encrypted boot)
	;&
    3) # GRUB (non-encrypted boot)
	arch-chroot /mnt cp $parent_dir/data/preloader-signed/{PreLoader,HashTool}.efi /boot/efi/EFI/archlinux
	arch-chroot /mnt cp /boot/efi/EFI/archlinux/grubx64.efi /boot/efi/EFI/archlinux/loader.efi
	arch-chroot /mnt efibootmgr --verbose --disk /dev/$install_dev --part $partnum --create --label "archlinuxsecure" --loader /EFI/archlinux/PreLoader.efi
	;;
esac


