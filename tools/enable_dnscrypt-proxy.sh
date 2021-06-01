#!/bin/bash

set -e

install_command="pacman -Syu --needed --noconfirm"

$install_command ddclient dnscrypt-proxy

# back up /etc/resolv.conf file
sudo cp /etc/resolv.conf /etc/resolv.conf.bak

# modify /etc/resolv.conf
printf "nameserver ::1\n" | sudo tee /etc/resolv.conf
printf "nameserver 127.0.0.1\n" | sudo tee -a /etc/resolv.conf
printf "options edns0 single-request-reopen\n" | sudo tee -a /etc/resolv.conf

# prevent /etc/resolv.conf from modified
sudo chattr +i /etc/resolv.conf

# start systemd service
sudo systemctl enable dnscrypt-proxy.service
sudo systemctl start dnscrypt-proxy.service

# restart Network Manager
sudo systemctl restart NetworkManager
