#!/bin/bash

set -e

GVT_DOM="0000:00"
GVT_PCI="0000:00:02.0"
GVT_TYPE="i915-GVTg_V5_2"
GVT_GUID="fdfd4e27-f44a-425f-b62d-e840a147b9cd"

echo "$GVT_GUID" > "/sys/devices/pci${GVT_DOM}/$GVT_PCI/mdev_supported_types/$GVT_TYPE/create"
