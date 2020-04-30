#!/bin/bash

set -e

sed -i "6 r ../data/preferredmirrors" /etc/pacman.d/mirrorlist
