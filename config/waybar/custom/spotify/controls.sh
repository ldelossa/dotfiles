#!/bin/bash

status=$(playerctl -p spotify status)

if [[ -z $status ]] 
then
    exit
fi

if [[ $1 == "prev" ]]
then
   playerctl -p spotify previous
   # we don't need to send a signal
   # ourselves, dunst is notified of
   # track changes and will do this instead.
   exit
fi

if [[ $1 == "next" ]]
then
   playerctl -p spotify next
   # we don't need to send a signal
   # ourselves, dunst is notified of
   # track changes and will do this instead.
   exit
fi

# if no option is provided we toggle
# the play state and send a signal to
# waybar to update it's css.
if [[ $status == "Playing" ]]
then
   playerctl -p spotify pause
   sleep .1
   # trigger the monitor to resync all
   # spotify elements
   pkill -RTMIN+4 waybar
   exit
fi

if [[ $status == "Paused" ]]
then
   playerctl -p spotify play
   sleep .1
   # trigger the monitor to resync all
   # spotify elements
   pkill -RTMIN+4 waybar
   exit
fi

