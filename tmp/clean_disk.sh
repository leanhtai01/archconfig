#!/bin/bash

set -e

dd if=/dev/zero of=/dev/sda bs=4M count=1
dd if=/dev/zero of=/dev/nvme0n1 bs=4M count=1
sgdisk -Z /dev/sda
sgdisk -Z /dev/nvme0n1
