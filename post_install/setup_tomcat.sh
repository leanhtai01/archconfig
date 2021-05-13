#!/bin/bash

set -e

version=8
parent_dir=$(cd $(dirname $0)/..; pwd)

sudo pacman -Syu --needed --noconfirm tomcat${version}
sudo gpasswd -a leanhtai01 tomcat${version}
sudo systemctl enable tomcat${version}
sudo systemctl start tomcat${version}

# for use tomcat in netbeans
[[ -d ~/.tomcat${version} ]] && rm -r ~/.tomcat${version}
mkdir ~/.tomcat${version}
sudo cp -r /etc/tomcat${version} ~/.tomcat${version}/conf
sudo chown -R $(id -un):$(id -gn) ~/.tomcat${version}
cp $parent_dir/data/tomcat-users.xml ~/.tomcat${version}/conf/tomcat-users.xml
mkdir ~/.tomcat${version}/webapps
ln -s /var/lib/tomcat${version}/webapps/manager ~/.tomcat${version}/webapps/manager
mkdir ~/.tomcat${version}/temp
