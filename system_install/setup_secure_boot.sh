#!/bin/bash

set -e

yay -Syu --noconfirm preloader-signed
sudo cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi /boot/efi/EFI/archlinux
sudo cp /boot/efi/EFI/archlinux/grubx64.efi /boot/efi/EFI/archlinux/loader.efi
sudo efibootmgr --verbose --disk /dev/nvme0n1 --part 2 --create --label "archlinuxsecure" --loader /EFI/archlinux/PreLoader.efi
