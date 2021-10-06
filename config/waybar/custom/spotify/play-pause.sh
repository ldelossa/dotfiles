#!/bin/bash

status=$(playerctl -p spotify status)

if [[ -z $status ]] 
then
    exit
fi

if [[ $status == "Playing" ]]
then
   echo "{\"text\": \"\", \"tooltip\": \"$album\"}"
   exit
fi

if [[ $status == "Paused" ]]
then
   echo "{\"text\": \"\", \"tooltip\": \"$album\"}"
   exit
fi
