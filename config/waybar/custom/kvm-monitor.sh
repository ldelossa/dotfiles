#!/bin/bash

IFS=$'\n'

vms=($(virsh --connect qemu:///system list | grep -e "[0-9]\+"))
n="${#vms[@]}"

tooltip="Virtual Machines:"
for vm in "${vms[@]}";
do
    tooltip="$tooltip\n$vm"
done

if [[ n -gt 0 ]] 
then
   echo "{\"class\": \"running\", \"text\": \"$n\", \"tooltip\": \"$tooltip\"}"
   exit
fi
