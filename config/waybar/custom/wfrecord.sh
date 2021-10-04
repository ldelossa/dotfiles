!/bin/bash

wf-recorder -o $(swaymsg -r -t get_outputs  | jq -r '.[] | select(.focused == true).name') -f $HOME/Videos/$(date -Is).mp4&
notify-send ' screen cap started'
