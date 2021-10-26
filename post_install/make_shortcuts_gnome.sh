#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)
SCHEMATOLIST="org.gnome.settings-daemon.plugins.media-keys"
SCHEMATOITEM="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
PATHTOCUSTOMKEY="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom"

gsettings set $SCHEMATOLIST custom-keybindings "['${PATHTOCUSTOMKEY}0/', '${PATHTOCUSTOMKEY}1/', '${PATHTOCUSTOMKEY}2/', '${PATHTOCUSTOMKEY}3/', '${PATHTOCUSTOMKEY}4/', '${PATHTOCUSTOMKEY}5/', '${PATHTOCUSTOMKEY}6/', '${PATHTOCUSTOMKEY}7/']"

# open Emacs
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}0/ name "'Emacs'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}0/ binding "'<Primary><Alt>e'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}0/ command "'emacs'"

# # open Chromium
# gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}1/ name "'Chromium'"
# gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}1/ binding "'<Primary><Alt>c'"
# gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}1/ command "'chromium'"

# open Google Chrome
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}1/ name "'Google Chrome'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}1/ binding "'<Primary><Alt>c'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}1/ command "'google-chrome-stable'"

# open GNOME Terminal - zsh
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}2/ name "'GNOME Terminal - zsh'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}2/ binding "'<Primary><Alt>r'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}2/ command "'gnome-terminal -e zsh'"

# open Nautilus
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}3/ name "'Nautilus'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}3/ binding "'<Super>e'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}3/ command "'nautilus'"

# open Krusader
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}4/ name "'Krusader'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}4/ binding "'<Primary><Alt>k'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}4/ command "'krusader'"

# open GNOME Terminal
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}5/ name "'GNOME Terminal'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}5/ binding "'<Primary><Alt>t'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}5/ command "'gnome-terminal'"

# open Firefox Developer Edition
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}6/ name "'Firefox Developer Edition'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}6/ binding "'<Primary><Alt>f'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}6/ command "'firefox-developer-edition'"

# # open GVim
# gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}7/ name "'GVim'"
# gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}7/ binding "'<Primary><Alt>v'"
# gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}7/ command "'gvim'"

# toggle touchpad
cp $parent_dir/tools/toggle_touchpad_gnome.sh /home/$(whoami)/.toggle_touchpad_gnome.sh
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}7/ name "'Toggle Touchpad'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}7/ binding "'<Super>t'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}7/ command "'/home/$(whoami)/.toggle_touchpad_gnome.sh'"
