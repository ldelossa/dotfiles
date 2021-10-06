#!/bin/bash

vms=$(virsh --connect qemu:///system list | grep -e "[0-9]\+")
n=$(echo -n $vms | grep -c '^')
tooltip=$(echo -n $vms | grep -e "[0-9]\+" | sed ':a; N; $!ba; s/\n/\\n/g')

if [[ n -gt 0 ]] 
then
   echo "{\"class\": \"running\", \"text\": \"$n\", \"tooltip\": \"$tooltip\"}"
   exit
fi
echo "{\"class\": \"\", \"tooltip\": \"no running vms\"}"
