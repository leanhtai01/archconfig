#!/bin/bash

set -e

id=$(xinput list | grep -Eio 'TouchPad\s*id\=[0-9]{1,2}' | grep -Eio '[0-9]{1,2}')
isEnabled=$(xinput list-props $id | grep 'Device Enabled' | awk '{print $4}')

if [ $isEnabled = 1 ]
then
    xinput disable $id
fi
