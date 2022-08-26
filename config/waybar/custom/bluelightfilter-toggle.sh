#!/bin/bash
if pgrep gammastep 
then
    pkill --signal SIGKILL gammastep
    pkill -RTMIN+8 waybar
    exit
fi 
gammastep &
# send signal to update monitor 
pkill -RTMIN+8 waybar
