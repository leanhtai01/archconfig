#!/bin/bash

set -e

SCHEMATOLIST="org.gnome.settings-daemon.plugins.media-keys"
SCHEMATOITEM="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
PATHTOCUSTOMKEY="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom"

gsettings set $SCHEMATOLIST custom-keybindings "['${PATHTOCUSTOMKEY}0/', '${PATHTOCUSTOMKEY}1/', '${PATHTOCUSTOMKEY}2/', '${PATHTOCUSTOMKEY}3/']"

# open Emacs
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}0/ name "'Emacs'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}0/ binding "'<Primary><Alt>e'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}0/ command "'emacs'"

# open Nautilus
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}1/ name "'Nautilus'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}1/ binding "'<Primary><Alt>f'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}1/ command "'nautilus'"

# open Chromium
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}2/ name "'Chromium'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}2/ binding "'<Primary><Alt>i'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}2/ command "'chromium'"

# open GNOME Terminal
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}3/ name "'GNOME Terminal'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}3/ binding "'<Primary><Alt>t'"
gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}3/ command "'gnome-terminal'"