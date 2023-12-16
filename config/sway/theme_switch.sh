#!/bin/bash

if [[ $1 == "dark" ]]
then
    unlink ~/.gitconfig
    ln -s ~/.config/git/gitconfig-dark ~/.gitconfig

    unlink ~/.config/sway/theme
    ln -s ~/.config/sway/theme-dark ~/.config/sway/theme

    unlink ~/.config/wob/wob.ini
    ln -s ~/.config/wob/wob-dark.ini ~/.config/wob/wob.ini

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

    unlink ~/.config/swaync/style.css
    ln -s ~/.config/swaync/style-dark.css ~/.config/swaync/style.css
    swaync-client -rs

    unlink ~/.config/k9s/skin.yml
    ln -s ~/.config/k9s/skin-dark.yml ~/.config/k9s/skin.yml

    unlink ~/.config/rofi/config.rasi
    ln -s ~/.config/rofi/config-dark.rasi ~/.config/rofi/config.rasi

    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
	gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

    kitty +kitten themes --cache-age -1 --reload-in=all Dark-theme

    ~/.config/sway/vscode_theme_switch --dark

    for sock in $(ls ~/.cache/nvim/nvim-*); do
        nvim --server $sock --remote-send '<C-\><C-n>:lua Dark_theme()<CR>'&
    done

    sway reload
    exit
fi

if [[ $1 == "light" ]]
then
    unlink ~/.gitconfig
    ln -s ~/.config/git/gitconfig-light ~/.gitconfig

    unlink ~/.config/sway/theme
    ln -s ~/.config/sway/theme-light ~/.config/sway/theme

    unlink ~/.config/wob/wob.ini
    ln -s ~/.config/wob/wob-light.ini ~/.config/wob/wob.ini

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

    unlink ~/.config/swaync/style.css
    ln -s ~/.config/swaync/style-light.css ~/.config/swaync/style.css
    swaync-client -rs

    unlink ~/.config/k9s/skin.yml
    ln -s ~/.config/k9s/skin-light.yml ~/.config/k9s/skin.yml

    unlink ~/.config/rofi/config.rasi
    ln -s ~/.config/rofi/config-light.rasi ~/.config/rofi/config.rasi

    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
	gsettings set org.gnome.desktop.interface gtk-theme Adwaita

    kitty +kitten themes --cache-age -1 --reload-in=all Light-theme

    ~/.config/sway/vscode_theme_switch --light

    for sock in $(ls ~/.cache/nvim/nvim-*); do
        nvim --server $sock --remote-send '<C-\><C-n>:lua Light_theme()<CR>'&
    done

    sway reload
    exit
fi

