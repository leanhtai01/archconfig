#!/bin/bash
set -e

mycommand=
while read line
do
    str=$(./add_backslash.sh "$line")
    echo $str
done < $1
