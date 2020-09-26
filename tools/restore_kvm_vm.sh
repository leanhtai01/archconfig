#!/bin/bash

set -e

disk_name=
xml_name=

read -e -p "Enter name of disk file: " disk_name
read -e -p "Enter xml file name: " xml_name

sudo cp $disk_name /var/lib/libvirt/images/
sudo virsh define $xml_name
