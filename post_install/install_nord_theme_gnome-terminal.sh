#!/bin/bash

set -e

function install_theme() {
    git clone https://github.com/arcticicestudio/nord-gnome-terminal.git
    cd nord-gnome-terminal/src
    ./nord.sh
}

install_theme
