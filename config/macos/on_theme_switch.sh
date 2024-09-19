#!/bin/bash

if [[ $1 == "dark" ]]
then
    unlink ~/.config/k9s/skins/skin.yaml
    ln -s ~/.config/k9s/skins/skin-dark.yaml ~/.config/k9s/skins/skin.yaml

    kitty +kitten themes --cache-age -1 --reload-in=all Dark-theme

    ~/.config/sway/vscode_theme_switch --dark

    for sock in $(ls ~/.cache/nvim/nvim-*); do
		if ! (nvim --server "$sock" --remote-send '<C-\><C-n>:lua set_dark_theme()<CR>' > /dev/null); then
			rm "$sock"
		fi
    done

	lima "/home/louis/.config/way-shell/on_theme_changed.sh" "dark" 1>&2 /dev/null

    exit
fi

if [[ $1 == "light" ]]
then

    unlink ~/.config/k9s/skins/skin.yaml
    ln -s ~/.config/k9s/skins/skin-light.yaml ~/.config/k9s/skins/skin.yaml

    kitty +kitten themes --cache-age -1 --reload-in=all Light-theme

    ~/.config/sway/vscode_theme_switch --light

    for sock in $(ls ~/.cache/nvim/nvim-*); do
		if ! (nvim --server "$sock" --remote-send '<C-\><C-n>:lua set_light_theme()<CR>' > /dev/null); then
			rm "$sock"
		fi
    done

	lima "/home/louis/.config/way-shell/on_theme_changed.sh" "light" 1>&2 /dev/null

    exit
fi
