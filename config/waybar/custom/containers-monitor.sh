#!/bin/bash
IFS=$'\n'

docker_containers=($(docker ps --format "{{ .Names }}\t{{ .Status }}" | column -t))
n="${#docker_containers[@]}"

podman_containers=($(podman ps --format "{{ .Names }}\t{{ .Status }}" | column -t))
n=$((n + "${#docker_containers[@]}"))

tooltip="Containers:"
for con in "${docker_containers[@]}";
do
    tooltip="$tooltip\n$con"
done

for con in "${podman_containers[@]}";
do
    tooltip="$tooltip\n$con"
done

if [[ n -gt 0 ]] 
then
   echo "{\"class\": \"running\", \"text\": \"$n\", \"tooltip\": \"$tooltip\"}"
   exit
fi
