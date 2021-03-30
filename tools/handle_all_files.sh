#!/bin/bash

FILES=OnlySourceCode/*.java

for f in $FILES
do
	inserted_line="package leanhtai01;\n"
	linum=$(sed -n '/^\/\/ GitHub.*/=' $f)
	sed -i "${linum} a ${inserted_line}" $f
done
