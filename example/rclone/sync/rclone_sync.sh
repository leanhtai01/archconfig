#!/bin/bash

set -e

rclone sync -P --filter-from filter_list.txt SOURCE remote:DESTINATION
