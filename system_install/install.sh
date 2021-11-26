#!/bin/bash

set -e

current_dir=$(dirname $0)
parent_dir=$(cd $(dirname $0)/..; pwd)
newusername=
desktop_environment=
gpu=
connect_to_wifi=
system_install_type=
desktop_install_type=
install_pipewire_audio_server=

if [ -z $connect_to_wifi ]
then
    read -e -p "Do you want connect to wifi? [y/N] " connect_to_wifi
fi

re="[yY]"
if [[ $connect_to_wifi =~ $re ]]
then
    $parent_dir/tools/connect_wifi_iwd.sh
fi

. $current_dir/install_base_system.sh
. $current_dir/install_gpu_driver.sh $gpu $newusername in_chroot
. $current_dir/install_audio.sh in_chroot

for type in $system_install_type
do
    case $type in
	core)
	    . $current_dir/install_core_packages.sh $newusername in_chroot $gpu
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
        php)
            . $current_dir/install_php_programming_env.sh in_chroot
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
	    . $current_dir/install_desktop_environment.sh "$desktop_environment" in_chroot $newusername "$desktop_install_type"
	    ;;
	games)
	    . $current_dir/install_games.sh in_chroot
	    ;;
    esac
done

