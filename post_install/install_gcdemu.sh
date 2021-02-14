#!/bin/bash

set -e

sudo systemctl enable cdemu-daemon
yay -Syu --noconfirm gcdemu
