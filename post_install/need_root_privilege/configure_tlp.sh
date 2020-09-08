#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm tlp acpi_call
sudo systemctl enable tlp
sudo systemctl start tlp
