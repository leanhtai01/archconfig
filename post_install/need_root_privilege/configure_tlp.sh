#!/bin/bash

set -e

pacman -Syu --needed --noconfirm tlp acpi_call
systemctl enable tlp
systemctl start tlp
