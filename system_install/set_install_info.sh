#!/bin/bash

set -e

install_dev= # nvme0n1
other_storage_dev= # (sda, sdb, sdc, mmcblk0,...)
size_of_ram=
newusername="leanhtai01"
realname="Lê Anh Tài"
user_choice= # 1 - normal install, 2 - LVM on LUKS, 4 - dual-boot with Windows 10 (normal install), 5- dual-boot with Windows 10 (LVM on LUKS)
bootloader= # 1 - systemd-boot, 2 - GRUB (encrypted boot), 3 - GRUB (non-encrypted boot)
setupsecureboot=
setupkeytool=
desktop_environment= # {GNOME KDEPlasma i3 none}
desktop_install_type=core # {core full}
gpu= # {intel, amd, nvidia, virtualbox, vmware}
hostname=
system_install_type="core optional python java javascript high_performance dotnet desktop" # {core optional python java javascript high_performance dotnet desktop games}
