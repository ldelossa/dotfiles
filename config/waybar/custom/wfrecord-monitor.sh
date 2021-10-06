#!/bin/bash
if pgrep wf-recorder &> /dev/null
then
   echo '{"class": "recording"}'
   exit
fi 
echo '{"class": ""}'

