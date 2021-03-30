#!/bin/bash

FILES=OnlySourceCode/*.java

for f in $FILES
do
    tmp=$(printf "$f" | rev | cut -d'/' -f1 | rev)
    file_name=$(printf "${tmp:0:-5}")
	cp $f NetBeansProjects/${file_name}/src/leanhtai01/${file_name}.java
done
