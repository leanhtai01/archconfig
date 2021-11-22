#!/bin/bash

set -e

# rsync -a --delete \
#       --exclude={"dir2","dir3","hello.txt"} \
#       source/ dest/

# rsync -a --delete \
#       --exclude "dir2" \
#       --exclude "dir3" \
#       --exclude "hello.txt" \
#       source/ dest/

rsync -a --delete -P --filter="merge filter_list.txt" SOURCE/ DESTINATION
