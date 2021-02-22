#!/bin/bash

set -e

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Unikey')]"
gsettings set org.gnome.desktop.interface gtk-im-module "'ibus'"
