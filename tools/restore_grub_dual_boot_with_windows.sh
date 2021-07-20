#!/bin/bash

set -e

swapon /dev/nvme0n1p5
mount /dev/nvme0n1p6 /mnt
mount /dev/nvme0n1p1 /mnt/boot/efi
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Arch Linux" --recheck
umount -R /mnt
