#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm ibus
mkdir -p /home/$(whoami)/git_repos/ibus-bamboo
git clone https://github.com/BambooEngine/ibus-bamboo /home/$(whoami)/git_repos/ibus-bamboo
(cd /home/$(whoami)/git_repos/ibus-bamboo && sudo make install)
ibus restart
