#!/usr/bin/env bash

set -e

pid_file="fixed_name.pid"

# ensure only one instance of script is running
if [ -f "$pid_file" ] && ps -p $(cat "$pid_file") > /dev/null
then
    # another instance of this script is running
    exit
fi

# write script's PID to pid-file
printf "$$" > "$pid_file"

# do some work
