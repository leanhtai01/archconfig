#!/bin/bash

set -e

username=$1
current_dir=$(dirname $0)

function get_config_user() {
    # mkdir -p /home/${username}/backup_files_emacs
    # mkdir -p /home/${username}/todo_list
    git clone https://github.com/leanhtai01/emacsconfig /home/${username}/.config/emacs
}

function get_config_root() {
    # sudo mkdir -p /root/backup_files_emacs
    # sudo mkdir -p /root/todo_list
    sudo git clone https://github.com/leanhtai01/emacsconfig /root/.config/emacs
}

$current_dir/install_lsp_server.sh
get_config_user
get_config_root

