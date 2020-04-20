#!/bin/bash
set -e

mycommand=
while read line
do
    str=$(./add_backslash.sh "$line")
    mycommand="sed -i \"/${str}/s/\/\/ //\" /usr/share/webapps/phpMyAdmin/config.inc.php"
    echo $mycommand
done < $1
