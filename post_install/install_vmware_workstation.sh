#!/bin/bash

set -e

yay -Syu --noconfirm vmware-workstation
sudo systemctl enable vmware-networks
sudo systemctl enable vmware-usbarbitrator
sudo systemctl enable vmware-hostd
sudo modprobe -a vmw_vmci vmmon
sudo /usr/lib/vmware/bin/vmware-vmx-debug --new-sn FF788-A1X86-08E9Q-5YN79-XV0YD
