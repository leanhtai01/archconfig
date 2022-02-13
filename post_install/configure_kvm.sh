#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm virt-manager qemu vde2 dnsmasq bridge-utils virt-viewer dmidecode edk2-ovmf iptables-nft swtpm
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
# sudo systemctl enable cockpit.socket
# sudo systemctl start cockpit.socket

sudo sed -i "/^#unix_sock_group = \"libvirt\"$/s/^#//" /etc/libvirt/libvirtd.conf
sudo sed -i "/^#unix_sock_rw_perms = \"0770\"$/s/^#//" /etc/libvirt/libvirtd.conf
sudo gpasswd -a $(whoami) libvirt
sudo gpasswd -a $(whoami) kvm
