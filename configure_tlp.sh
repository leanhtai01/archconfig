#!/bin/bash

set -e

systemctl enable bluetooth
systemctl start tlp
