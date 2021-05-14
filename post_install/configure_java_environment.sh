#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/setup_tomcat.sh
$current_dir/configure_jdbc.sh
$current_dir/configure_java_CLASSPATH.sh
