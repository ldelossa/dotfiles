#!/bin/bash

status=$(playerctl -p spotify status)
artist=$(playerctl metadata xesam:artist)
title=$(playerctl metadata xesam:title)
album=$(playerctl metadata xesam:album)

if [[ -z $status ]] 
then
   # spotify is dead, we should die to.
   exit
fi

if [[ $status == "Playing" ]]
then
   echo "{\"class\": \"playing\", \"text\": \"$artist - $title\", \"tooltip\": \"$artist - $title - $album\"}"
   exit
fi

if [[ $status == "Paused" ]]
then
   echo "{\"class\": \"paused\", \"text\": \"$artist - $title\", \"tooltip\": \"$album\"}"
   exit
fi

