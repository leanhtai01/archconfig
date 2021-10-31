#!/bin/bash

set -e

password=

# ask user for disk's password
if [ -z "$password" ]
then
    read -e -p "Enter disk's password: " password
fi

# create keyfile
sudo mkdir -p /etc/luks-keys/
printf "$password" | sudo tee /etc/luks-keys/luks_data_drive > /dev/null
sudo chmod 600 /etc/luks-keys/

printf 'luks_data_drive UUID=4d9848e9-a41c-41b9-aadf-b514abd02ecc /etc/luks-keys/luks_data_drive nofail\n' | sudo tee -a /etc/crypttab > /dev/null
printf '/dev/disk/by-uuid/5650d5fa-aec0-4941-889f-6b785f016ca6 /run/media/leanhtai01/data_drive auto nosuid,nodev,nofail,x-gvfs-show 0 0\n' | sudo tee -a /etc/fstab > /dev/null
