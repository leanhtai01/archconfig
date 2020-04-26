#!/bin/bash

set -e

# swap caplocks - left ctrl
wget https://raw.githubusercontent.com/leanhtai01/archlinuxconfiguration/master/swap_caps_left_ctrl_console.sh
bash swap_caps_left_ctrl_console.sh

# setup mirrors
wget https://raw.githubusercontent.com/leanhtai01/archlinuxconfiguration/master/setup_mirrors.sh
bash setup_mirrors.sh

# install git
pacman -Sy --noconfirm git

# # setup git user mail and name
# git config --global user.email ""
# git config --global user.name ""

# clone archlinuxconfigurion repo
git clone https://github.com/leanhtai01/archlinuxconfiguration

# remove unused file
rm swap_caps_left_ctrl_console.sh setup_mirrors.sh
