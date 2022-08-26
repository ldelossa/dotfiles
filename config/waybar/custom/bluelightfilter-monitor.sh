#!/bin/bash
if pgrep gammastep &> /dev/null
then
   echo '{"class": "activated"}'
   exit
fi 
echo '{"class": ""}'
