#!/bin/bash

set -e

current_dir=$(dirname $0)

git reset --hard
git pull --ff-only
git stash pop
$current_dir/system_install/install.sh
