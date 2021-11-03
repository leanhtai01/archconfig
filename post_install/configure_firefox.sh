#!/bin/bash

set -e

mkdir -p /home/$(whoami)/.config/environment.d
printf "MOZ_ENABLE_WAYLAND=1" > /home/$(whoami)/.config/environment.d/firefox.conf
