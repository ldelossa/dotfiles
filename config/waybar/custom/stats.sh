#!/bin/bash

if ! pgrep alacritty
then
    alacritty -e gtop&
fi

swaymsg workspace stats
