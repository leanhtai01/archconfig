#!/bin/bash

set -e

# install Apache
pacman -Syu --needed --noconfirm apache
systemctl enable httpd
systemctl start httpd

# install MariaDB
pacman -Syu --needed --noconfirm mariadb
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
systemctl enable mariadb
systemctl start mariadb
mysql_secure_installation

# install PHP
pacman -Syu --needed --noconfirm php php-apache
linum=$(sed -n '/^;date.timezone =$/=' /etc/php/php.ini)
sed -i "${linum}s/^;//" /etc/php/php.ini
sed -i "${linum}s/=/& Asia\/Ho_Chi_Minh/" /etc/php/php.ini
