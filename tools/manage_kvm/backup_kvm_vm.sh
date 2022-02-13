#!/bin/bash

set -e

disk_name=
xml_name=
nvram_name=
vm_name=

sudo virsh list --all
read -e -p "Enter KVM virtual machine name: " vm_name
disk_name=${vm_name}.qcow2
xml_name=${vm_name}.xml
nvram_name=${vm_name}_VARS.fd

# make directory for vm
mkdir ${vm_name}

# copy disk file
sudo cp /var/lib/libvirt/images/${vm_name}.qcow2 ${vm_name}

# dump vm's xml
sudo virsh dumpxml $vm_name > ${vm_name}/${xml_name}

# dump snapshots
mkdir -p ${vm_name}/snapshots
snapshots=$(sudo virsh snapshot-list --name --topological "$vm_name")
for s in $snapshots
do
    sudo virsh snapshot-dumpxml "$vm_name" "$s" > ${vm_name}/snapshots/${s}.xml
done

# copy nvram file
if [[ -f "/var/lib/libvirt/qemu/nvram/${nvram_name}" ]]
then
    sudo cp /var/lib/libvirt/qemu/nvram/${nvram_name} ${vm_name}
fi

printf "Backup complete!\n"
