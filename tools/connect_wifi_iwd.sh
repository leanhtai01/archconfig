#!/bin/bash

set -e

PASSPHRASE=
DEVICE=
SSID=
is_hidden="y"

if [ -z $PASSPHRASE ]
then
    read -e -p "Enter passphrase: " PASSPHRASE
fi

if [ -z $DEVICE ]
then
    iwctl device list
    read -e -p "Enter device: " DEVICE
fi

if [ -z $SSID ]
then
    iwctl station "$DEVICE" scan
    iwctl station "$DEVICE" get-hidden-access-points
    iwctl station "$DEVICE" get-networks
fi

iwctl device list
if [ $is_hidden = "y" ]
then
    iwctl --passphrase="$PASSPHRASE" station "$DEVICE" connect-hidden "$SSID"
else
    iwctl --passphrase="$PASSPHRASE" station "$DEVICE" connect "$SSID"
fi
sleep 10

# test internet
ping -c 3 www.google.com
