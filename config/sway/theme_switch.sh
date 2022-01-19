#!/bin/bash

if [[ $1 == "dark" ]]
then
    unlink ~/.config/sway/theme
    ln -s ~/.config/sway/theme-dark ~/.config/sway/theme

    unlink ~/.config/sway/wob.sh
    ln -s ~/.config/sway/wob-dark.sh ~/.config/sway/wob.sh

    unlink ~/.config/waybar/style.css
    ln -s ~/.config/waybar/style-single-bar.css ~/.config/waybar/style.css

    unlink ~/.config/gtk-4.0/settings.ini
    ln -s ~/.config/gtk-4.0/settings-dark.ini ~/.config/gtk-4.0/settings.ini

    unlink ~/.config/gtk-3.0/settings.ini
    ln -s ~/.config/gtk-3.0/settings-dark.ini ~/.config/gtk-3.0/settings.ini

    unlink ~/.config/wofi/style.css
    ln -s ~/.config/wofi/style-dark.css ~/.config/wofi/style.css

    unlink ~/.config/alacritty/alacritty.yml
    ln -s ~/.config/alacritty/alacritty-dark.yml ~/.config/alacritty/alacritty.yml

    gsettings set org.gnome.desktop.interface gtk-theme 'Materia-dark-compact'

    kitty +kitten themes --cache-age -1 --reload-in=all Dark-theme

    for socket in $(nvr --serverlist); do 
        nvr --servername $socket --nostart --remote-send '<esc> dm'&
    done

    sway reload
    sleep 4
    ps aux | grep nvr | cut -f 5 -d " " | xargs kill -SIGKILL
    exit
fi

if [[ $1 == "light" ]]
then
    unlink ~/.config/sway/theme
    ln -s ~/.config/sway/theme-light ~/.config/sway/theme

    unlink ~/.config/sway/wob.sh
    ln -s ~/.config/sway/wob-light.sh ~/.config/sway/wob.sh

    unlink ~/.config/waybar/style.css
    ln -s ~/.config/waybar/style-single-bar-light.css ~/.config/waybar/style.css

    unlink ~/.config/gtk-4.0/settings.ini
    ln -s ~/.config/gtk-4.0/settings-light.ini ~/.config/gtk-4.0/settings.ini

    unlink ~/.config/gtk-3.0/settings.ini
    ln -s ~/.config/gtk-3.0/settings-light.ini ~/.config/gtk-3.0/settings.ini

    unlink ~/.config/wofi/style.css
    ln -s ~/.config/wofi/style-light.css ~/.config/wofi/style.css

    unlink ~/.config/alacritty/alacritty.yml
    ln -s ~/.config/alacritty/alacritty-light.yml ~/.config/alacritty/alacritty.yml

    gsettings set org.gnome.desktop.interface gtk-theme 'Materia-light-compact'

    kitty +kitten themes --cache-age -1 --reload-in=all Light-theme

    for socket in $(nvr --serverlist); do 
        nvr --servername $socket --remote-send '<esc> lm'& 
    done
    sway reload
    sleep 4
    ps aux | grep nvr | cut -f 5 -d " " | xargs kill -SIGKILL
    exit
fi

