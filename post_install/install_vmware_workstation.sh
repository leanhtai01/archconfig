#!/bin/bash

set -e

yay -Syu --noconfirm vmware-workstation
sudo systemctl enable vmware-networks
sudo systemctl enable vmware-usbarbitrator
# sudo modprobe -a vmw_vmci vmmon
sudo /usr/lib/vmware/bin/vmware-vmx-debug --new-sn ZF3R0-FHED2-M80TY-8QYGC-NPKYF
