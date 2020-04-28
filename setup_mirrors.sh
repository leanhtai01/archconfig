#!/bin/bash

set -e

# current country
linum=$(sed -n '/^Server = http:\/\/f.archlinuxvn.org\/archlinux\/\$repo\/os\/\$arch$/=' /etc/pacman.d/mirrorlist) # find a line and get line number
preferredmirror=$(sed -n "$linum"p /etc/pacman.d/mirrorlist) # get line know line number
sed -i '6 a ## My preferred mirrors' /etc/pacman.d/mirrorlist # insert line after
sed -i "7 a $preferredmirror" /etc/pacman.d/mirrorlist

# best of tier 1
sed -i "8 a Server = http:\/\/ftp.sh.cvut.cz\/arch\/\$repo\/os\/\$arch$" /etc/pacman.d/mirrorlist

# best of tier 2
sed -i "9 a Server = http:\/\/mirror.i3d.net\/pub\/archlinux\/\$repo\/os\/\$arch$" /etc/pacman.d/mirrorlist
