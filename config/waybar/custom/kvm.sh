#!/bin/bash

if ! pgrep virt-manager
then
    virt-manager&
fi

swaymsg workspace vm
