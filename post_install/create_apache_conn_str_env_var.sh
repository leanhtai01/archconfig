#!/bin/bash

set -e

username=leanhtai01
password=123
hostname=localhost
port=3306
database=basicfb_db
varname=DB_URL

mkdir -p /home/$(whoami)/apache_config/
printf "SetEnv $varname \"mysql://$username:$password@$hostname:$port/$database\"\n" > /home/$(whoami)/apache_config/environment_variables.conf
