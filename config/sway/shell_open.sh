#!/bin/bash

workspace=$(swaymsg -t get_workspaces -r | jq -r -c '.[] | select(.focused == true) | .name')

IFS=':' read -ra cdpaths <<< "$CDPATH"
for path in "${cdpaths[@]}"; do
    echo "$path/$workspace"
    if [[ -d "$path/$workspace" ]]; then
        swaymsg exec "$TERM --detach --working-directory \"$path/$workspace\""
        exit
    fi
done
swaymsg exec "$TERM --detach"
