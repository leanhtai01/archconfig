#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

# mkdir -p /home/$(whoami)/manual_install_packages/ibus-bamboo
# git clone https://github.com/BambooEngine/ibus-bamboo /home/$(whoami)/manual_install_packages/ibus-bamboo
# (cd /home/$(whoami)/manual_install_packages/ibus-bamboo && sudo make install)
# yay -Syu --noconfirm xorg-fonts-misc-otb
yay -Syu --noconfirm ibus-bamboo xorg-fonts-misc-otb

if [ $1 = "KDEPlasma" ]
then
    mkdir -p /home/$(whoami)/.config/environment.d
    cp $parent_dir/data/ibus_config_data /home/$(whoami)/.config/environment.d/ibus.conf
fi

if [ $1 = "GNOME" ]
then
    ibus restart
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"
    gsettings set org.gnome.desktop.interface gtk-im-module "'ibus'"
fi
