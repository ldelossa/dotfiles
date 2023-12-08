#!/bin/bash 

p="$HOME/git/devspaces"

if [[ -d "$p" ]]; then
    source $p/shell-functions.sh
	alias ds=devspace
fi

