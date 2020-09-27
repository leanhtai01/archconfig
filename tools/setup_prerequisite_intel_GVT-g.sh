#!/bin/bash

set -e

sudo sed -i "/^MODULES=()/s/(/&kvmgt vfio-iommu-type1 vfio-mdev/" /etc/mkinitcpio.conf
sudo sed -i "/^options/s/rw/& intel_iommu=on i915.enable_gvt=1 i915.enable_guc=0/" /boot/loader/entries/archlinux.conf
sudo mkinitcpio -p linux
