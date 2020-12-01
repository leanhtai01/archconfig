#!/bin/bash

set -e

netbeans &
PID=`jobs -p`

sleep 60
kill $PID
