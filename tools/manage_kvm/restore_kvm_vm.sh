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
if [ ! -f ${vm_name}/${disk_name} ]
then
    read -e -p "Enter disk's size: " disk_size
    sudo qemu-img create -f qcow2 /var/lib/libvirt/images/${disk_name} ${disk_size}G
else
    sudo cp ${vm_name}/$disk_name /var/lib/libvirt/images/
fi

sudo virsh define ${vm_name}/$xml_name

# redefine snapshots
while read snap_xml
do
    (cd ${vm_name}/snapshots && sudo virsh snapshot-create --redefine "$vm_name" "$snap_xml")
done < ${vm_name}/snapshots_structure

# copy nvram file
sudo cp ${vm_name}/$nvram_name /var/lib/libvirt/qemu/nvram/

printf "Restore complete!\n"

