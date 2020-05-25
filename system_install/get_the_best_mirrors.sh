#!/bin/bash

set -e

reflector --latest 10 --protocol http --protocol https --sort rate | sed -n '/^Server.*/,$p' > /etc/pacman.d/mirrorlist
