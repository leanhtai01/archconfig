#!/bin/bash

set -e

current_dir=$(dirname $0)
closest_country="CN TW VN SG TH US GB RU JP IN"

mkdir $current_dir/tmp

for country in $closest_country
do
    curl -s "https://www.archlinux.org/mirrorlist/?country=$country&protocol=http&protocol=https&ip_version=4&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' >> $current_dir/tmp/closestmirrors
done

reflector --latest 5 --protocol http --protocol https --sort rate | sed -n '/^Server.*/,$p' >> $current_dir/tmp/closestmirrors
rankmirrors -n 5 $current_dir/tmp/closestmirrors > /etc/pacman.d/mirrorlist

