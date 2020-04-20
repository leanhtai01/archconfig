#!/bin/bash
set -e

re="[]$\[\/\"]"
esc_char='\'
str=$1
result_str=
while [ -n "$str" ]
do
    tmp=${str#?}
    char=${str%"$tmp"}
    if [[ "$char" =~ $re ]]
    then
	result_str="${result_str}${esc_char}"
    fi
    result_str="${result_str}${char}"
    str=$tmp
done

echo $result_str
