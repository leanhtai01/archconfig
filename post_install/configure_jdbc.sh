#!/bin/bash

set -e

yay -Syu --noconfirm mariadb-jdbc
printf "export CLASSPATH=\"\${CLASSPATH}:/usr/share/java/mariadb-jdbc/mariadb-java-client.jar\"\n" > /home/$(whoami)/.xprofile
