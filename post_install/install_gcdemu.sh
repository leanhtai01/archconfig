#!/bin/bash

set -e

sudo modprobe -a sg sr_mod vhba
yay -Syu --noconfirm gcdemu
