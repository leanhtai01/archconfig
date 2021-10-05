#!/bin/bash

set -e

username=$1
current_dir=$(dirname $0)

function getconfig() {
    cd /home/${username}
    mkdir -p backup_files_emacs
    git clone https://github.com/leanhtai01/.emacs.d
}

$current_dir/install_lsp_server.sh
getconfig

