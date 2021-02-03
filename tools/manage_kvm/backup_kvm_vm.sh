#!/bin/bash

set -e

# vm_name=

# sudo virsh list --all
# read -e -p "Enter KVM virtual machine name: " vm_name

# sudo cp /var/lib/libvirt/images/${vm_name}.qcow2 .
# sudo virsh dumpxml $vm_name > ${vm_name}.xml

disk_name=
xml_name=
nvram_name=
vm_name=

sudo virsh list --all
read -e -p "Enter KVM virtual machine name: " vm_name
disk_name=${vm_name}.qcow2
xml_name=${vm_name}.xml
nvram_name=${vm_name}_VARS.fd

# copy disk file
sudo cp /var/lib/libvirt/images/${vm_name}.qcow2 .

# dump vm's xml
sudo virsh dumpxml $vm_name > ${vm_name}.xml

# dump snapshots
mkdir -p snapshots
snapshots=$(sudo virsh snapshot-list --name "$vm_name")
for s in $snapshots
do
    sudo virsh snapshot-dumpxml "$vm_name" "$s" > snapshots/${s}.xml
done

# copy nvram file
sudo cp /var/lib/libvirt/qemu/nvram/${nvram_name} .

printf "Backup complete!\n"
