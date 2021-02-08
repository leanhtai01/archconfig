#!/bin/bash

set -e

path_to_iso=$1
current_dir=$(dirname $0)

# get path to iso
if [ -z "$path_to_iso" ]
then
    read -e -p "Enter path to original iso: " path_to_iso
fi

# extract iso
mkdir -p extracted_contents
$current_dir/extract_iso.sh "$path_to_iso" extracted_contents

# get full path to file iso
file_name=$(readlink -f "$path_to_iso")

# get the name of file iso
tmp=$(printf "$file_name" | rev | cut -d'/' -f1 | rev)
iso_name=$(printf "${tmp:0:-4}")

# processing
(
    cd extracted_contents/"$iso_name";
    ls -l;
    
    read -e -p "Enter list of file, dir need to removed: " removed_list
    for removed in $removed_list
    do
	rm -r "$removed";
    done
)

# make new iso
iso-info "$file_name"
mkdir -p new_iso
read -e -p "Enter volume name: " volume_name
read -e -p "Enter the file name of iso: " new_file_name
$current_dir/make_iso_from_dir.sh "$volume_name" new_iso/"$new_file_name" extracted_contents/"$iso_name"

# delete tmp file
rm -r extracted_contents/
