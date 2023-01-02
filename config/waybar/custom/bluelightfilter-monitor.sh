#!/bin/bash
if pgrep gammastep &> /dev/null
then
   echo '{"class": "activated", "tooltip": "activated"}'
   exit
fi 
echo '{"class": "", "tooltip": "deactivated"}'
