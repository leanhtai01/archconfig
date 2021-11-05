#!/bin/bash

set -e

mkdir -p ~/.local/share/gnome-shell/extensions
(
    cd ~/.local/share/gnome-shell/extensions
    git clone https://github.com/daniellandau/switcher.git switcher@landau.fi
)
