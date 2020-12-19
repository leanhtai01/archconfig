#!/bin/bash

set -e

# swap Ctrl - CapsLock
# gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:rwin_switch', 'ctrl:swapcaps']"

# swap CapsLock - Esc
gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:rwin_switch', 'caps:swapescape']"

# set applications theme to dark
gsettings set org.gnome.desktop.interface gtk-theme "'Adwaita-dark'"

# show battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true

# show weekday
gsettings set org.gnome.desktop.interface clock-show-weekday true

# show date
gsettings set org.gnome.desktop.interface clock-show-date true

# change fonts to Hack
gsettings set org.gnome.desktop.interface font-name "'Hack 10'"
gsettings set org.gnome.desktop.interface document-font-name "'Hack 11'"
gsettings set org.gnome.desktop.interface monospace-font-name "'Hack 10'"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "'Hack Bold 11'"

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

# set cursor theme
# gsettings set org.gnome.desktop.interface cursor-theme "'ArchCursorTheme'"

# set default folder viewer nautilus
gsettings set org.gnome.nautilus.preferences default-folder-viewer "'list-view'"

# empty favorite-apps
gsettings set org.gnome.shell favorite-apps "[]"

# switch windows
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
