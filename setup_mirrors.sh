#!/bin/bash

set -e

linum=$(sed -n '/^Server = http:\/\/f.archlinuxvn.org\/archlinux\/\$repo\/os\/\$arch$/=' /etc/pacman.d/mirrorlist) # find a line and get line number
preferredmirror=$(sed -n "$linum"p /etc/pacman.d/mirrorlist) # get line know line number
sed -i '6 a ## My preferred mirrors' /etc/pacman.d/mirrorlist # insert line after
sed -i "7 a $preferredmirror" /etc/pacman.d/mirrorlist
