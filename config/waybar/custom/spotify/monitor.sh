#!/bin/bash

# we are a clock for the other
# spotify elements.
# 
# waybar will run this on an interval
# and external processes can trigger this 
# with pkill -RTMIN+4 waybar
sleep .1
pkill -RTMIN+5 waybar

# if spotify is running, trigger the
# render of the "quit" element.
if pgrep spotify > /dev/null
then
    pkill -RTMIN+6 waybar
fi

