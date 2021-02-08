#!/bin/bash

set -e

path_to_iso=$1
dest=$2

# get path to iso
if [ -z "$path_to_iso" ]
then
    read -e -p "Enter path to iso: " path_to_iso
fi

# get destination to store extracted contents
if [ -z "$dest" ]
then
    read -e -p "Enter destination to store extracted contents: " dest
fi

# get full path to file iso
file_name=$(readlink -f "$path_to_iso")

# get the name of file iso
tmp=$(printf "$file_name" | rev | cut -d'/' -f1 | rev)
iso_name=$(printf "${tmp:0:-4}")

# extract iso
output_dir="$dest"/"$iso_name"
7z x "$file_name" -o"$output_dir"
