#!/bin/bash

swaymsg workspace stats
if [ "$1" == "cpu" ]; then
    kitty "htop" "-s" "PERCENT_CPU"
    exit
fi

if [ "$1" == "memory" ]; then
    kitty "htop" "-s" "M_RESIDENT"
    exit
fi

kitty "htop"
exit
