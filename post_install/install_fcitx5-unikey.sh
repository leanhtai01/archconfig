#!/bin/bash

set -e

parent_dir=$(cd $(dirname $0)/..; pwd)

sudo pacman -Syu --needed --noconfirm fcitx5-im fcitx5-unikey fcitx5-qt fcitx5-gtk

mkdir -p /home/$(whoami)/.config/environment.d
cp $parent_dir/data/fcitx5.conf /home/$(whoami)/.config/environment.d/
