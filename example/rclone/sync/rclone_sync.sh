#!/bin/bash

set -e

rclone sync -P --filter-from filter-list.txt SOURCE remote:DESTINATION
