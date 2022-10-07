#!/usr/bin/bash
if [[ -e /proc/acpi/button/lid/LID0/state  ]]; then
    if grep -q open /proc/acpi/button/lid/LID0/state; then
        swaymsg output eDP-1 enable
    else
        swaymsg output eDP-1 disable
    fi
fi

if [[ -e /proc/acpi/button/lid/LID/state  ]]; then
    if grep -q open /proc/acpi/button/lid/LID0/state; then
        swaymsg output eDP-1 enable
    else
        swaymsg output eDP-1 disable
    fi
fi
