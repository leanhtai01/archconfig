#!/bin/bash

set -e

PASSPHRASE=
DEVICE=
SSID=
is_hidden=

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

    if [ -z $is_hidden ]
    then
	read -e -p "Is the wifi hidden? [y/N] " is_hidden
    fi
    
    read -e -p "Enter ssid: " SSID
fi

if [ -z $PASSPHRASE ]
then
    read -e -p "Enter passphrase: " PASSPHRASE
fi

iwctl device list
re="[yY]"
if [[ $is_hidden =~ $re ]]
then
    iwctl --passphrase="$PASSPHRASE" station "$DEVICE" connect-hidden "$SSID"
else
    iwctl --passphrase="$PASSPHRASE" station "$DEVICE" connect "$SSID"
fi
sleep 10

# test internet
ping -c 3 8.8.8.8
