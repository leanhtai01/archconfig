#!/bin/bash

set -e

yay -Syu --needed --noconfirm ibus-bamboo
cat data/ibus_config_data > ~/.xprofile
