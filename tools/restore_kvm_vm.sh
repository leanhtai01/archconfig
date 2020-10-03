#!/bin/bash

set -e

disk_name=
xml_name=

ls -l
read -e -p "Enter name of disk file: " disk_name
read -e -p "Enter xml file name: " xml_name

if [ ! -f "$disk_name" ]
then
    read -e -p "Enter disk's size: " disk_size
    sudo qemu-img create -f qcow2 /var/lib/libvirt/images/${disk_name} ${disk_size}G
else
    sudo cp $disk_name /var/lib/libvirt/images/
fi

sudo virsh define $xml_name
printf "Restore complete!\n"
