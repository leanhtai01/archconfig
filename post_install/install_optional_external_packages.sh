#!/bin/bash

set -e

current_dir=$(dirname $0)

$current_dir/install_azure_data_studio.sh
$current_dir/install_logisim-evolution.sh
$current_dir/install_mssql.sh
$current_dir/install_qtspim.sh
$current_dir/install_teamviewer.sh
$current_dir/install_vdhcoapp.sh
$current_dir/install_zoom.sh
