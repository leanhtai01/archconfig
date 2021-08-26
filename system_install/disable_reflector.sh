#!/bin/bash

set -e

systemctl disable reflector.service
systemctl disable reflector.timer
systemctl stop reflector.service
systemctl stop reflector.timer

