#!/bin/bash

set -e

GVT_PCI="0000:00:02.0"
GVT_GUID="fdfd4e27-f44a-425f-b62d-e840a147b9cd"

echo 1 > /sys/bus/pci/devices/$GVT_PCI/$GVT_GUID/remove
