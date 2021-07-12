#!/bin/bash

set -e

version=
parent_dir=$(cd $(dirname $0)/..; pwd)

# ask user for version of tomcat
display_menu()
{
    printf "\nChoose tomcat's version:\n"
    printf "1. Version 8\n"
    printf "2. Version 9\n"
    printf "3. Version 10\n"
    printf "Enter your choice: "
}

if [ -z $version ]
then
    re="[1-3]"

    display_menu()
    read choice

    while [[ ! "$choice" =~ $re ]]
    do
	printf "\nInvalid choice! Please try again!\n"
	display_menu
	read choice
    done

    case $choice in
	1)
	    version=8
	    ;;
	2)
	    version=9
	    ;;
	3)
	    version=10
	    ;;
    esac
fi

sudo pacman -Syu --needed --noconfirm tomcat${version}
sudo gpasswd -a leanhtai01 tomcat${version}
# sudo systemctl enable tomcat${version}
# sudo systemctl start tomcat${version}
sudo cp $parent_dir/data/tomcat-users.xml /usr/share/tomcat${version}/conf/tomcat-users.xml
sudo chown root:tomcat${version} /usr/share/tomcat${version}/conf/tomcat-users.xml

# for use tomcat in netbeans
[[ -d /home/$(whoami)/.tomcat${version} ]] && rm -r /home/$(whoami)/.tomcat${version}
mkdir /home/$(whoami)/.tomcat${version}
sudo cp -r /etc/tomcat${version} /home/$(whoami)/.tomcat${version}/conf
sudo chown -R $(id -un):$(id -gn) /home/$(whoami)/.tomcat${version}
cp $parent_dir/data/tomcat-users.xml.netbeans /home/$(whoami)/.tomcat${version}/conf/tomcat-users.xml
mkdir /home/$(whoami)/.tomcat${version}/webapps
ln -s /var/lib/tomcat${version}/webapps/manager /home/$(whoami)/.tomcat${version}/webapps/manager
mkdir /home/$(whoami)/.tomcat${version}/temp
