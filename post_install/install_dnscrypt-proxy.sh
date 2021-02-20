#!/bin/bash

sudo pacman -Syu --needed --noconfirm dnscrypt-proxy

# back up /etc/resolv.conf file
sudo cp /etc/resolv.conf /etc/resolv.conf.bak

# modify /etc/resolv.conf
sudo printf "nameserver ::1\n" > /etc/resolv.conf
sudo printf "nameserver 127.0.0.1\n" >> /etc/resolv.conf
sudo printf "options edns0 single-request-reopen\n" >> /etc/resolv.conf

# prevent /etc/resolv.conf from modified
sudo chattr +i /etc/resolv.conf

# start systemd service
sudo systemctl enable dnscrypt-proxy.service
sudo systemctl start dnscrypt-proxy.service
