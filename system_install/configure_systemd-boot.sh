#!/bin/bash

set -e

# variables
root_partnum=6
luks_partnum=5

case $bootloader in
    1) # systemd-boot
        root_partnum=7
        ;;
esac

arch-chroot /mnt bootctl --esp-path=/efi --boot-path=/boot install
echo "default archlinux" > /mnt/efi/loader/loader.conf
echo "timeout 5" >> /mnt/efi/loader/loader.conf
echo "console-mode keep" >> /mnt/efi/loader/loader.conf
echo "editor no" >> /mnt/efi/loader/loader.conf

echo "title Arch Linux" > /mnt/boot/loader/entries/archlinux.conf
echo "linux /vmlinuz-linux" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /intel-ucode.img" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/archlinux.conf

case $user_choice in
    1) # normal install
	rootuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}4)
	echo "options root=UUID=${rootuuidvalue} rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    2) # lvm on luks
	cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}3)
	echo "options cryptdevice=UUID=${cryptlvmuuidvalue}:cryptlvm root=/dev/sys_vol_group/root rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    3) # luks on lvm
	;&
    6) # dual-boot with Windows 10 (LUKS on LVM)
	cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/sys_vol_group/cryptroot)
	echo "options cryptdevice=UUID=${cryptlvmuuidvalue}:root root=/dev/mapper/root rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    4) # dual-boot with Windows 10 (normal install)
	rootuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}${root_partnum})
	echo "options root=UUID=${rootuuidvalue} rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    5) # dual-boot with Windows 10 (LVM on LUKS)
	cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}${luks_partnum})
	echo "options cryptdevice=UUID=${cryptlvmuuidvalue}:cryptlvm root=/dev/sys_vol_group/root rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
esac

re="[36]"
if [[ ! $user_choice =~ $re ]] # not setup hibernation for LUKS on LVM
then
    sed -i "/^options.*/s/rw/resume=UUID=${swapuuidvalue} &/" /mnt/boot/loader/entries/archlinux.conf
fi
