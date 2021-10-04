#!/bin/bash

set -e

# get the current values
two_finger_scrolling_enabled=$(dconf read /org/gnome/desktop/peripherals/touchpad/two-finger-scrolling-enabled)
edge_scrolling_enabled=$(dconf read /org/gnome/desktop/peripherals/touchpad/edge-scrolling-enabled)
tap_to_click=$(dconf read /org/gnome/desktop/peripherals/touchpad/tap-to-click)

if [ $two_finger_scrolling_enabled = "true" ]
then
    gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled false
else
    gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
fi

if [ $edge_scrolling_enabled = "true" ]
then
    gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled false
else
    gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled true
fi

if [ $tap_to_click = "true" ]
then
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click false
else
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
fi



