#!/bin/bash

if ! pgrep alacritty
then
    alacritty -e gotop&
fi

swaymsg workspace stats
