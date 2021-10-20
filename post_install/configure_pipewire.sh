#!/bin/bash

set -e

mkdir -p ~/.config/pipewire
cp /usr/share/pipewire/{client.conf,pipewire-pulse.conf} ~/.config/pipewire
sed -i '/resample.quality/s/#//; /resample.quality/s/4/10/' ~/.config/pipewire/{client.conf,pipewire-pulse.conf}
systemctl --user enable pipewire-media-session.service
