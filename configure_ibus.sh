#!/bin/bash

set -e

yay -Syu --needed --noconfirm ibus-bamboo
cp data/my_xprofile_file ~/.xprofile
