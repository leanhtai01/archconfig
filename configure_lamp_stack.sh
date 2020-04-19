#!/bin/bash

set -e

##################
# install Apache #
##################
pacman -Syu --needed --noconfirm apache
systemctl enable httpd
systemctl start httpd

###################
# install MariaDB #
###################
pacman -Syu --needed --noconfirm mariadb
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
systemctl enable mariadb
systemctl start mariadb
mysql_secure_installation

###############
# install PHP #
###############
pacman -Syu --needed --noconfirm php php-apache

# set timezone
linum=$(sed -n '/^;date.timezone =$/=' /etc/php/php.ini)
sed -i "${linum}s/^;//" /etc/php/php.ini
sed -i "${linum}s/=/& Asia\/Ho_Chi_Minh/" /etc/php/php.ini

# comment line LoadModule mpm_event_module modules/mod_mpm_event.so
linum=$(sed -n '/^LoadModule mpm_event_module modules\/mod_mpm_event.so$/=' /etc/httpd/conf/httpd.conf)
sed -i "${linum}s/^/#&/" /etc/httpd/conf/httpd.conf

# uncomment line LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
sed -i "/^#LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so$/s/^#//" /etc/httpd/conf/httpd.conf

# place some line at the end of the LoadModule list:
linum=$(sed -n '/^#\?LoadModule /=' /etc/httpd/conf/httpd.conf | tail -1)
# sed -i "${linum}G" /etc/httpd/conf/httpd.conf
# ((linum++))
sed -i "${linum} a LoadModule php7_module modules\/libphp7.so" /etc/httpd/conf/httpd.conf
((linum++))
sed -i "${linum} a AddHandler php7-script .php" /etc/httpd/conf/httpd.conf

# place some line at the end of the Include list
linum=$(sed -n '/^#\?Include /=' /etc/httpd/conf/httpd.conf | tail -1)

