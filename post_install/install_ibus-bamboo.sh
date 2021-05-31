#!/bin/bash

set -e

# mkdir -p /home/$(whoami)/my_programs/ibus-bamboo
# git clone https://github.com/BambooEngine/ibus-bamboo /home/$(whoami)/my_programs/ibus-bamboo
# (cd /home/$(whoami)/my_programs/ibus-bamboo && sudo make install)
yay -Syu --noconfirm ibus-bamboo
ibus restart

# gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"
# gsettings set org.gnome.desktop.interface gtk-im-module "'ibus'"
