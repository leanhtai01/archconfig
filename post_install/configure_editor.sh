#!/bin/bash

set -e

username=$1
current_dir=$(dirname $0)

function get_config_user() {
    # mkdir -p /home/${username}/backup_files_emacs
    # mkdir -p /home/${username}/todo_list
    git clone https://github.com/leanhtai01/.emacs.d /home/${username}/.emacs.d
}

function get_config_root() {
    # sudo mkdir -p /root/backup_files_emacs
    # sudo mkdir -p /root/todo_list
    sudo git clone https://github.com/leanhtai01/.emacs.d /root/.emacs.d
}

$current_dir/install_lsp_server.sh
get_config_user
get_config_root

