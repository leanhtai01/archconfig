#!/bin/bash

set -e

printf "$1\n" | sudo tee /sys/class/power_supply/BAT0/charge_start_threshold
printf "$2\n" | sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold
