#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm clamav
sudo freshclam
sudo systemctl enable clamav-freshclam.service
sudo systemctl enable clamav-daemon.service
