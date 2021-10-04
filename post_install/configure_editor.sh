#!/bin/bash

set -e

username=$1
current_dir=$(dirname $0)

function getconfig() {
    cd /home/${username}
    mkdir -p backup_files_emacs
    mkdir -p desktop_saves_emacs
    git init -b main
    git remote add origin https://github.com/leanhtai01/editorconfig
    git pull --ff-only --set-upstream origin main
}

getconfig
$current_dir/install_lsp_server.sh
