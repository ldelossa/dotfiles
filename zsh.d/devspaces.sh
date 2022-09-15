#!/bin/bash 

p="$HOME/git/devspaces"

function devspace() {
    cd "$p"/"$1" || return
    make run
}

function devspace-list() {
    docker ps | head -n 1
    docker ps | grep "devspace/"
}
