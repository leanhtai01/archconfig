#!/bin/bash

set -e

mkdir -p /home/$(whoami)/.config/environment.d
# printf "MOZ_ENABLE_WAYLAND=1\n" > /home/$(whoami)/.config/environment.d/firefox.conf
printf "EDITOR=emacs\n" > /home/$(whoami)/.config/environment.d/editor.conf
# printf "PATH=\$PATH:/home/$(whoami)/.config/composer/vendor/bin\n" > /home/$(whoami)/.config/environment.d/custom_path.conf
# printf "PATH=\$PATH:/home/$(whoami)/go/bin\n" >> /home/$(whoami)/.config/environment.d/custom_path.conf
