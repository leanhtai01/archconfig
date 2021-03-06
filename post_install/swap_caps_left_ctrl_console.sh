#!/bin/bash

# exit script immediately on error
set -e

sudo mkdir -p /usr/local/share/kbd/keymaps
sudo cp /usr/share/kbd/keymaps/i386/qwerty/us.map.gz /usr/local/share/kbd/keymaps/
sudo gunzip /usr/local/share/kbd/keymaps/us.map.gz
sudo mv /usr/local/share/kbd/keymaps/us.map /usr/local/share/kbd/keymaps/personal.map

# make the Right Alt key same as Left Alt key
linum=$(sed -n '/^include "linux-with-alt-and-altgr"$/=' /usr/local/share/kbd/keymaps/personal.map)
sudo sed -i "${linum} a include \"linux-with-two-alt-keys\"" /usr/local/share/kbd/keymaps/personal.map

# swap Caps_Lock and Left Control
linum=$(sed -n '/^keycode  29 = Control$/=' /usr/local/share/kbd/keymaps/personal.map)
sudo sed -i "${linum}s/Control/Caps_Lock/" /usr/local/share/kbd/keymaps/personal.map
linum=$(sed -n '/^keycode  58 = Caps_Lock$/=' /usr/local/share/kbd/keymaps/personal.map)
sudo sed -i "${linum}s/Caps_Lock/Control/" /usr/local/share/kbd/keymaps/personal.map

# make use of the personal keymap
sudo loadkeys /usr/local/share/kbd/keymaps/personal.map

# load the keymap at boot
echo "KEYMAP=/usr/local/share/kbd/keymaps/personal.map" | sudo tee /etc/vconsole.conf
