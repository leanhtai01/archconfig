#!/bin/bash

set -e

# swap Ctrl - CapsLock
gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:rwin_switch', 'ctrl:swapcaps']"

# set applications theme to dark
gsettings set org.gnome.desktop.interface gtk-theme "'Adwaita-dark'"

# show battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true

# show weekday
gsettings set org.gnome.desktop.interface clock-show-weekday true

# show date
gsettings set org.gnome.desktop.interface clock-show-date true

# show week number
gsettings set org.gnome.desktop.calendar show-weekdate true

# disable touchpad
gsettings set org.gnome.desktop.peripherals.touchpad send-events "'disabled'"

# disable suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type "'nothing'"
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "'nothing'"

# enable Night Light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 18.0
