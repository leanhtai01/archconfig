#!/bin/bash

set -e

# driver installation
case $1 in
    intel)
	$install_command lib32-vulkan-icd-loader vulkan-icd-loader vulkan-intel intel-media-driver lib32-vulkan-intel lib32-mesa mesa ocl-icd lib32-ocl-icd intel-compute-runtime
	;;
    amd)
	;;
    nvidia)
	;;
    virtualbox)
	$install_command virtualbox-guest-utils virtualbox-guest-dkms
	${prefix}systemctl enable vboxservice
	${prefix}gpasswd -a $2 vboxsf
	;;
    vmware)
	;;
esac
