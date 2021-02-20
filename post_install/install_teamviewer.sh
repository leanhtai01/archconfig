#!/bin/bash

set -e

yay -Syu --noconfirm teamviewer
sudo systemctl enable teamviewerd.service
sudo systemctl start teamviewerd.service
