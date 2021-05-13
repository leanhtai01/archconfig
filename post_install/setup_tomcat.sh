#!/bin/bash

set -e

version=8
parent_dir=$(cd $(dirname $0)/..; pwd)

sudo pacman -Syu --needed --noconfirm tomcat${version}
sudo gpasswd -a leanhtai01 tomcat${version}
sudo systemctl enable tomcat${version}
sudo systemctl start tomcat${version}
sudo cp $parent_dir/data/tomcat-users.xml /usr/share/tomcat8/conf/tomcat-users.xml
sudo chown root:tomcat${version} /usr/share/tomcat8/conf/tomcat-users.xml

# for use tomcat in netbeans
[[ -d /home/$(whoami)/.tomcat${version} ]] && rm -r /home/$(whoami)/.tomcat${version}
mkdir /home/$(whoami)/.tomcat${version}
sudo cp -r /etc/tomcat${version} /home/$(whoami)/.tomcat${version}/conf
sudo chown -R $(id -un):$(id -gn) /home/$(whoami)/.tomcat${version}
cp $parent_dir/data/tomcat-users.xml.netbeans /home/$(whoami)/.tomcat${version}/conf/tomcat-users.xml
mkdir /home/$(whoami)/.tomcat${version}/webapps
ln -s /var/lib/tomcat${version}/webapps/manager /home/$(whoami)/.tomcat${version}/webapps/manager
mkdir /home/$(whoami)/.tomcat${version}/temp
