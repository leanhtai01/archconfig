#!/bin/bash

set -e

install_command="yay -Syu --needed --noconfirm"

$install_command gnome-shell-extension-appindicator-git gnome-shell-extension-vitals-git
