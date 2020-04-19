#!/bin/bash

set -e

# install Apache
pacman -Syu --needed --noconfirm apache
systemctl enable httpd
systemctl start httpd

# install MariaDB


