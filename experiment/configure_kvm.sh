#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
else
    prefix="sudo "
fi

INSTALL_KVM=$($prefix expect -c "
set pid [spawn pacman -Syu --needed virt-manager qemu vde2 dnsmasq bridge-utils virt-viewer dmidecode edk2-ovmf cockpit cockpit-machines iptables-nft]

expect \":: iptables-nft and iptables are in conflict. Remove iptables? \[y/N\]\"
send \"y\r\"

expect \":: Proceed with installation? \[Y/n\]\"
send \"y\r\"

expect eof

wait $pid
")

echo "${INSTALL_KVM}"

$prefix systemctl enable libvirtd
$prefix systemctl enable cockpit.socket

$prefix sed -i "/^#unix_sock_group = \"libvirt\"$/s/^#//" /etc/libvirt/libvirtd.conf
$prefix sed -i "/^#unix_sock_rw_perms = \"0770\"$/s/^#//" /etc/libvirt/libvirtd.conf
$prefix gpasswd -a $2 libvirt
$prefix gpasswd -a $2 kvm
