#!/bin/bash
IFS=$'\n'

containers=($(docker ps --format "{{ .Names }}\t{{ .Status }}" | column -t))
n="${#containers[@]}"

tooltip="Containers:"
for con in "${containers[@]}";
do
    tooltip="$tooltip\n$con"
done

if [[ n -gt 0 ]] 
then
   echo "{\"class\": \"running\", \"text\": \"$n\", \"tooltip\": \"$tooltip\"}"
   exit
fi
echo "{\"class\": \"\",\"text\": \" \", \"tooltip\": \"no running containers\"}"
