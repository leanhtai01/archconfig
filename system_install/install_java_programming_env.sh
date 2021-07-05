#!/bin/bash

set -e

prefix=

if [ ! -z $1 ] && [ $1 = "in_chroot" ]
then
    prefix="arch-chroot /mnt "
fi

install_command="${prefix}pacman -Syu --needed --noconfirm"

$install_command netbeans maven
$install_command jdk-openjdk openjdk-doc java-openjfx
$install_command jdk8-openjdk openjdk8-doc java8-openjfx
$install_command jdk11-openjdk openjdk11-doc java11-openjfx
