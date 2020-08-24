#!/bin/bash

set -e

current_dir=$(dirname $0)
closest_countries="CN TW VN SG"

mkdir $current_dir/tmp

for country in $closest_countries
do
    curl -s "https://www.archlinux.org/mirrorlist/?country=$country&protocol=http&protocol=https&ip_version=4&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' >> $current_dir/tmp/closestmirrors
done

reflector --latest 5 --protocol http --protocol https --sort rate | sed -n '/^Server.*/,$p' >> $current_dir/tmp/closestmirrors
rankmirrors -n 5 $current_dir/tmp/closestmirrors > /etc/pacman.d/mirrorlist

# try the best mirror 3 times before move forward
linum=$(sed -n '/^Server.*/=' /etc/pacman.d/mirrorlist | head -1)
bestmirror=$(sed -n "${linum}"p /etc/pacman.d/mirrorlist)
for i in {1..2..1}
do    
    sed -i "${linum} a ${bestmirror}" /etc/pacman.d/mirrorlist
done


