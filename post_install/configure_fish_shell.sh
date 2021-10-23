#!/bin/fish

# set -U fish_color_command #D8DEE9
# set -U fish_color_param #4C566A
# set -U fish_color_param normal
# set | grep fish_color
sudo pacman -Syu --needed --noconfirm fish

set -U fish_greeting
fish_config prompt choose nim
fish_update_completions

