#!/usr/bin/env bash

set -e

if pidof -x $(basename $0) -o %PPID > /dev/null
then
    printf "Already running!\n" >> ~/tmp/test_output.txt
else
    printf "Date: $(date)\n" >> ~/tmp/test_output.txt
fi

