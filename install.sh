#!/bin/bash

set -e

wget https://raw.githubusercontent.com/leanhtai01/archlinuxconfiguration/master/setup_install_env.sh
bash setup_install_env.sh
rm setup_install_env.sh

bash archlinuxconfiguration/install_base_system.sh
rm -r archlinuxconfiguration
