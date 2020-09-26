#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm virt-manager qemu vde2 ebtables dnsmasq bridge-utils virt-viewer dmidecode edk2-ovmf
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

sudo sed -i "/^#unix_sock_group = \"libvirt\"$/s/^#//" /etc/libvirt/libvirtd.conf
sudo sed -i "/^#unix_sock_rw_perms = \"0770\"$/s/^#//" /etc/libvirt/libvirtd.conf
sudo gpasswd -a $(whoami) libvirt
sudo gpasswd -a $(whoami) kvm
