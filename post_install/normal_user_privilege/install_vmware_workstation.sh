#!/bin/bash

set -e

yay -Syu --noconfirm vmware-workstation
sudo systemctl enable vmware-networks
sudo systemctl enable vmware-usbarbitrator
sudo systemctl enable vmware-hostd
sudo modprobe -a vmw_vmci vmmon
