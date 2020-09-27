#!/bin/bash

set -e

sed -i "/^MODULES=()/s/(/&kvmgt vfio-iommu-type1 vfio-mdev/" /etc/mkinitcpio.conf
sed -i "/^options/s/rw/& intel_iommu=on i915.enable_gvt=1 i915.enable_guc=0/" /boot/loader/entries/archlinux.conf
mkinitcpio -p linux
