#!/bin/bash

set -e

mkdir -p /home/$(whoami)/.config/environment.d
# printf "MOZ_ENABLE_WAYLAND=1\n" > /home/$(whoami)/.config/environment.d/firefox.conf
printf "EDITOR=emacs\n" > /home/$(whoami)/.config/environment.d/editor.conf
