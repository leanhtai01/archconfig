#!/bin/bash

set -e

mkdir -p /home/$(whoami)/.config/environment.d
printf "CLASSPATH=\"\${CLASSPATH}:/usr/share/tomcat8/lib/servlet-api.jar:/usr/share/java/mariadb-jdbc/mariadb-java-client.jar\"\n" > /home/$(whoami)/.config/environment.d/java_classpath.conf
