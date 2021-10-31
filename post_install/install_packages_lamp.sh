#!/bin/bash

set -e

# install Apache
sudo pacman -Syu --needed --noconfirm apache
sudo systemctl enable httpd
sudo systemctl start httpd

# install MariaDB
sudo pacman -Syu --needed --noconfirm mariadb expect
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable mariadb
sudo systemctl start mariadb

# install PHP
sudo pacman -Syu --needed --noconfirm php php-apache php-gd

# install phpMyAdmin
sudo pacman -Syu --needed --noconfirm phpmyadmin

# install MySQL Workbench
# sudo pacman -Syu --needed --noconfirm mysql-workbench

# install dbeaver
# sudo pacman -Syu --needed --noconfirm dbeaver
