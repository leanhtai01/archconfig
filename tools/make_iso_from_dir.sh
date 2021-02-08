#!/bin/bash

set -e

volume_name=$1
new_file_name=$2
path_to_dir=$3

# collect information
if [ -z "$volume_name" ]
then
    read -e -p "Enter volume name: " volume_name
fi

if [ -z "$new_file_name" ]
then
    read -e -p "Enter the file name of iso: " new_file_name
fi

if [ -z "$path_to_dir" ]
then
    read -e -p "Enter path to directory: " path_to_dir
fi

# make iso
mkisofs -JR -V "$volume_name" -o "$new_file_name" "$path_to_dir"
