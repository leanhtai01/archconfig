#!/bin/bash

set -e

sudo freshclam
sudo systemctl enable clamav-freshclam.service
sudo systemctl enable clamav-daemon.service
