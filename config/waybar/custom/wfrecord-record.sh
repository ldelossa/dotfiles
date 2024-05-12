#!/bin/bash

wf-recorder -c libx264 -x yuv420p -o $(swaymsg -r -t get_outputs  | jq -r '.[] | select(.focused == true).name') -f $HOME/Videos/$(date -Is).mp4 &> /dev/null &
notify-send ' screen cap started'
sleep .1

# send signal to update monitor 
pkill -RTMIN+8 waybar

