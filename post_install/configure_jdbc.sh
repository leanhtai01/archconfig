#!/bin/bash

set -e

yay -Syu --noconfirm mariadb-jdbc
mkdir -p /home/$(whoami)/.config/environment.d
printf "CLASSPATH=\"\${CLASSPATH}:/usr/share/java/mariadb-jdbc/mariadb-java-client.jar\"\n" > /home/$(whoami)/.config/environment.d/java_classpath.conf
