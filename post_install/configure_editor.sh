#!/bin/bash

set -e

username=$1

function getconfig() {
    cd /home/${username}
    git init -b main
    git remote add origin https://github.com/leanhtai01/editorconfig
    git pull --ff-only --set-upstream origin main
}

getconfig
