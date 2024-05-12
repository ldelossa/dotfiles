#!/bin/bash
source /home/louis/zsh.d/env.sh

TERM=kitty
workspace=$1

IFS=':' read -ra cdpaths <<< "$CDPATH"
for path in "${cdpaths[@]}"; do
    if [[ -d "$path/$workspace" ]]; then
        $TERM --detach --working-directory "$path/$workspace"
        exit
    fi
done
