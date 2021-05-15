#!/bin/bash

set -e

yay -Syu --noconfirm mariadb-jdbc
mkdir -p /home/$(whoami)/.config/environment.d
