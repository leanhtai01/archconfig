#!/bin/bash

set -e

disk_name=
xml_name=
nvram_name=
vm_name=

ls -l
read -e -p "Enter KVM virtual machine name: " vm_name
disk_name=${vm_name}.qcow2
xml_name=${vm_name}.xml
nvram_name=${vm_name}_VARS.fd

# copy disk file
if [ ! -f "$disk_name" ]
then
    read -e -p "Enter disk's size: " disk_size
    sudo qemu-img create -f qcow2 /var/lib/libvirt/images/${disk_name} ${disk_size}G
else
    sudo cp $disk_name /var/lib/libvirt/images/
fi

sudo virsh define $xml_name

# redefine snapshots
snapshots_xml=$(ls snapshots)
for xml in $snapshots_xml
do
    (cd snapshots && sudo virsh snapshot-create --redefine "$vm_name" "$xml")
done

# copy nvram file
sudo cp $nvram_name /var/lib/libvirt/qemu/nvram/

printf "Restore complete!\n"

