#!/bin/bash

set -e

prefix=

if [ ! -z $3 ] && [ $3 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

# driver installation
case $1 in
    intel)
	$install_command lib32-vulkan-icd-loader vulkan-icd-loader vulkan-intel intel-media-driver lib32-vulkan-intel lib32-mesa mesa ocl-icd lib32-ocl-icd intel-compute-runtime libva-utils
	;;
    amd)
	;;
    nvidia)
	;;
    virtualbox)
	$install_command virtualbox-guest-utils
	${prefix}systemctl enable vboxservice
	${prefix}gpasswd -a $2 vboxsf
	;;
    vmware)
	;;
esac
