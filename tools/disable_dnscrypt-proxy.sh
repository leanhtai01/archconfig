#!/bin/bash

set -e

# stop/disable service
sudo systemctl stop dnscrypt-proxy.service
sudo systemctl disable dnscrypt-proxy.service

# remove write protected file /etc/resolv.conf
sudo chattr -i /etc/resolv.conf

# restore file /etc/resolv.conf from backup
sudo cp /etc/resolv.conf.bak /etc/resolv.conf

# restart NetworkManager
sudo systemctl restart NetworkManager
