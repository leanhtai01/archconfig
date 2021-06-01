#!/bin/bash

set -e

current_dir=$(dirname $0)
parent_dir=$(cd $(dirname $0)/..; pwd)
newusername=
desktop_environment=
gpu=
connect_to_wifi=
system_install_type=

if [ -z $connect_to_wifi ]
then
    read -e -p "Do you want connect to wifi? [y/N] " connect_to_wifi
fi

re="[yY]"
if [[ $connect_to_wifi =~ $re ]]
then
    $parent_dir/tools/connect_wifi_iwd.sh
fi

for type in $system_install_type
do
    case $type in
	base)
	    . $current_dir/install_base_system.sh
	    . $current_dir/install_gpu_driver.sh $gpu $newusername in_chroot
	    ;;
	core)
	    . $current_dir/install_core_packages.sh $newusername in_chroot
	    ;;
	optional)
	    . $current_dir/install_optional_packages.sh $newusername in_chroot
	    ;;
	python)
	    . $current_dir/install_python_programming_env.sh in_chroot
	    ;;
	java)
	    . $current_dir/install_java_programming_env.sh in_chroot
	    ;;
	javascript)
	    . $current_dir/install_javascript_programming_env.sh in_chroot
	    ;;
	high_performance)
	    . $current_dir/install_high_performance_programming_env.sh in_chroot
	    ;;
	dotnet)
	    . $current_dir/install_dotnet_programming_env.sh in_chroot
	    ;;
	desktop)
	    . $current_dir/install_desktop_environment.sh "$desktop_environment" in_chroot $newusername
	    ;;
	games)
	    . $current_dir/install_games.sh in_chroot
	    ;;
    esac
done

