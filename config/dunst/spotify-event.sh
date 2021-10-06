#!/bin/bash

# send signal to update spotify monitor
# this will resync all spotify waybar
# elements
sleep .1
pkill -RTMIN+4 waybar

