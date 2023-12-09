#!/bin/bash

function sws() {
    swaymsg -t get_workspaces -r | jq -c '.[] | .name' | fzf --color | xargs swaymsg workspace
    exit
}

function sts() {
    id=$(swaymsg -t get_tree| jq -c -r 'recurse(.nodes[]?) | recurse(.floating_nodes[]?) | select(.type=="con"), select(.type=="floating_con") | {id, app_id, name}' | fzf --color | jq .id)
    swaymsg [con_id="$id"] focus
    exit
}

function sm() {
    swaymsg mark $1
}

function sms() {
    mark=$(swaymsg -t get_marks | jq '.[]' | fzf --color)
    swaymsg [con_mark="$mark"] focus
    exit
}

# unplugs all virtual outputs.
function sway-unplug { 
	for a in $(echo $(swaymsg -t get_outputs --raw | jq ".[].name" | grep HEAD)); do sway output $a unplug; done 
}
