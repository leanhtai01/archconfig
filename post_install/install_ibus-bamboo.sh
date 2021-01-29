#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm ibus
mkdir -p /home/$(whoami)/git_repos/ibus-bamboo
git clone https://github.com/BambooEngine/ibus-bamboo /home/$(whoami)/git_repos/ibus-bamboo
(cd /home/$(whoami)/git_repos/ibus-bamboo && sudo make install)

ibus-daemon -drx
ibus restart

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"
gsettings set org.gnome.desktop.interface gtk-im-module "'ibus'"
