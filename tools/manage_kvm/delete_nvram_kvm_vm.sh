#!/bin/bash

set -e

vm_name=

sudo virsh list --all
read -e -p "Enter KVM virtual machine name: " vm_name

sudo virsh undefine --nvram "$vm_name"
