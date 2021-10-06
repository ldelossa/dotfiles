#!/bin/bash

if ! pgrep pavucontrol
then
    pavucontrol&
fi

swaymsg workspace sound
