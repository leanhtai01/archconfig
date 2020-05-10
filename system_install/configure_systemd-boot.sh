#!/bin/bash

set -e

arch-chroot /mnt bootctl install
echo "default archlinux" > /mnt/boot/loader/loader.conf
echo "timeout 5" >> /mnt/boot/loader/loader.conf
echo "console-mode keep" >> /mnt/boot/loader/loader.conf
echo "editor no" >> /mnt/boot/loader/loader.conf

echo "title Arch Linux" > /mnt/boot/loader/entries/archlinux.conf
echo "linux /vmlinuz-linux" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /intel-ucode.img" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/archlinux.conf

case $user_choice in
    1) # normal install
	rootuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}3)
	echo "options root=UUID=${rootuuidvalue} rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    2) # lvm on luks
	cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}2)
	echo "options cryptdevice=UUID=${cryptlvmuuidvalue}:cryptlvm root=/dev/sys_vol_group/root rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    3) # luks on lvm
	;&
    6) # dual-boot with Windows 10 (LUKS on LVM)
	cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/sys_vol_group/cryptroot)
	echo "options cryptdevice=UUID=${cryptlvmuuidvalue}:root root=/dev/mapper/root rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    4) # dual-boot with Windows 10 (normal install)
	rootuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}6)
	echo "options root=UUID=${rootuuidvalue} rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
    5) # dual-boot with Windows 10 (LVM on LUKS)
	cryptlvmuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}5)
	echo "options cryptdevice=UUID=${cryptlvmuuidvalue}:cryptlvm root=/dev/sys_vol_group/root rw" >> /mnt/boot/loader/entries/archlinux.conf
	;;
esac

# setup hibernation
re="[36]"
if [[ ! $user_choice =~ $re ]] # not setup hibernation for LUKS on LVM
then
    linum=$(arch-chroot /mnt sed -n '/^HOOKS=.*filesystems.*/=' /etc/mkinitcpio.conf)
    arch-chroot /mnt sed -i "${linum}s/filesystems/& resume/" /etc/mkinitcpio.conf
    arch-chroot /mnt mkinitcpio -p linux
fi

swapuuidvalue=
case $user_choice in
    1) # normal install
	swapuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}2)
	;;
    4) # dual-boot with Windows 10 (normal install)
	swapuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/${install_dev}${part}5)
	;;
    2) # lvm on luks
	;&
    5) # dual-boot with Windows 10 (LVM on LUKS)
	swapuuidvalue=$(arch-chroot /mnt blkid -s UUID -o value /dev/sys_vol_group/swap)
	;;
esac

re="[36]"
if [[ ! $user_choice =~ $re ]] # not setup hibernation for LUKS on LVM
then
    echo "options resume=UUID=${swapuuidvalue}" >> /mnt/boot/loader/entries/archlinux.conf
fi

# configure fstab and crypttab for swap (LUKS on LVM)
re="[36]"
if [[ $user_choice =~ $re ]]
then
    # crypttab
    printf "swap    /dev/sys_vol_group/cryptswap    /dev/urandom    swap,cipher=aes-cbc-essiv:sha256,size=256\n" >> /mnt/etc/crypttab

    # fstab
    printf "/dev/mapper/swap    none    swap    sw    0 0\n" >> /mnt/etc/fstab
fi
