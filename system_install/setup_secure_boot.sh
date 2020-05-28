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
        cp $parent_dir/data/preloader-signed/{PreLoader,HashTool}.efi /mnt/boot/EFI/systemd
        cp /mnt/boot/EFI/systemd/systemd-bootx64.efi /mnt/boot/EFI/systemd/loader.efi
	arch-chroot /mnt efibootmgr --verbose --disk /dev/$install_dev --part $partnum --create --label "archlinuxsecure" --loader /EFI/systemd/PreLoader.efi
	;;
    2) # GRUB (encrypted boot)
	;&
    3) # GRUB (non-encrypted boot)
        cp $parent_dir/data/preloader-signed/{PreLoader,HashTool}.efi /mnt/boot/efi/EFI/archlinux
        cp /mnt/boot/efi/EFI/archlinux/grubx64.efi /mnt/boot/efi/EFI/archlinux/loader.efi
	arch-chroot /mnt efibootmgr --verbose --disk /dev/$install_dev --part $partnum --create --label "archlinuxsecure" --loader /EFI/archlinux/PreLoader.efi
	;;
esac


