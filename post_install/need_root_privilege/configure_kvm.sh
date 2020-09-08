#!/bin/bash

set -e

# make place to save original config files (if not exist)
original_config_files_path=$(dirname $0)/original_config_files
if [ ! -d "$original_config_files_path" ]
then
    mkdir $original_config_files_path
fi

pacman -Syu --needed --noconfirm virt-manager qemu vde2 ebtables dnsmasq bridge-utils virt-viewer dmidecode
systemctl enable libvirtd
systemctl start libvirtd

cp /etc/libvirt/libvirtd.conf $original_config_files_path
printf "libvirtd.conf: /etc/libvirt/libvirtd.conf\n" >> $original_config_files_path/original_path.txt
sed -i "/^#unix_sock_group = \"libvirt\"$/s/^#//" /etc/libvirt/libvirtd.conf
sed -i "/^#unix_sock_rw_perms = \"0770\"$/s/^#//" /etc/libvirt/libvirtd.conf
gpasswd -a $(whoami) libvirt
