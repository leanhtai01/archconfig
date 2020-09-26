#!/bin/bash

set -e

vm_name=

sudo virsh list --all
read -e -p "Enter KVM virtual machine name: " vm_name

sudo cp /var/lib/libvirt/images/${vm_name}.qcow2 .
sudo virsh dumpxml $vm_name > ${vm_name}.xml
printf "Backup complete!\n"
