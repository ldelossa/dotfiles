#!/bin/bash

if [[ $1 == "dark" ]]
then
    unlink ~/.config/sway/config
    ln -s ~/.config/sway/config-dark ~/.config/sway/config
    unlink ~/.config/waybar/style.css
    ln -s ~/.config/waybar/style-single-bar.css ~/.config/waybar/style.css
    sway reload
    exit
fi

if [[ $1 == "light" ]]
then
    unlink ~/.config/sway/config
    ln -s ~/.config/sway/config-light ~/.config/sway/config
    unlink ~/.config/waybar/style.css
    ln -s ~/.config/waybar/style-single-bar-light.css ~/.config/waybar/style.css
    sway reload
    exit
fi

