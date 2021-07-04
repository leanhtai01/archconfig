#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

# mkdir -p /home/$(whoami)/my_programs/ibus-bamboo
# git clone https://github.com/BambooEngine/ibus-bamboo /home/$(whoami)/my_programs/ibus-bamboo
# (cd /home/$(whoami)/my_programs/ibus-bamboo && sudo make install)
yay -Syu --noconfirm ibus-bamboo

if [ $1 = "KDEPlasma" ]
then
    cp $parent_dir/data/ibus_config_data /home/$(whoami)/.xprofile
fi

if [ $1 = "GNOME" ]
then
    ibus restart
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"
    gsettings set org.gnome.desktop.interface gtk-im-module "'ibus'"
fi
