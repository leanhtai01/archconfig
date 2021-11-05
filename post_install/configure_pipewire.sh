#!/bin/bash

set -e

mkdir -p ~/.config/pipewire
cp -r /usr/share/pipewire/* ~/.config/pipewire
sed -i '/resample.quality/s/#//; /resample.quality/s/4/10/' ~/.config/pipewire/{client.conf,pipewire-pulse.conf}
sed -i '/suspend-node/s/suspend-node/#suspend-node/' ~/.config/pipewire/media-session.d/media-session.conf
systemctl --user enable pipewire-media-session.service
