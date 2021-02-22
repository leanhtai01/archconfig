#!/bin/bash

set -e

mkdir -p ~/.cache/yay/packettracer
(cd ~/.cache/yay/packettracer && gdown https://drive.google.com/uc?id=1LBibB4uSWElbZe0gSl4tlkJ5avXCdBcO)
yay -Syu --noconfirm packettracer
