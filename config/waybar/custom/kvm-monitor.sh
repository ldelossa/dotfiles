#!/bin/bash

if  virsh --connect qemu:///system list | tail -n +3 | grep -e "[0-9]\+" > /dev/null
then
   echo '{"class": "running"}'
    exit
fi
echo '{"class": ""}'
