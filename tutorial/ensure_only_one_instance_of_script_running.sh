#!/bin/bash

# must be using /bin/bash not /usr/bin/env bash for pidof (see pidof manpage)

set -e

if pidof -x $(basename $0) -o %PPID > /dev/null
then
    printf "Already running!\n"
else
    printf "Do something!\n"
    sleep 20
fi
