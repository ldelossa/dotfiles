#!/bin/bash

function hosts-list() {
	# change array iteration to new lines
	IFS_OLD=$IFS
	IFS=$'\n'

	lines=($(cat /etc/hosts))

	# iterate over lines and echo is not a comment
	id=1
	for line in "${lines[@]}"; do
		if [[ ! "$line" =~ ^# ]]; then
			echo ${id}. "$line"
			id=$((id + 1))
		fi
	done

	# restore IFS
	IFS=$IFS_OLD
}

function hosts-add() {
	echo "${1}" "${2}" | sudo tee -a /etc/hosts > /dev/null
}

function hosts-remove() {
	# change array iteration to new lines
	IFS_OLD=$IFS
	IFS=$'\n'

	lines=($(cat /etc/hosts))
	filtered_lines=()

	# iterate over lines and echo is not a comment
	id=1
	for line in "${lines[@]}"; do
		if [[ ! "$line" =~ ^# ]]; then
			id=$((id + 1))
			filtered_lines+=("$line")
		fi
	done

	# ${1} is the ID of the host file line to remove in /etc/hosts.
	# So find the line in filtered_lines and then remove the line that matches
	# in the hosts file
	line_to_remove=${filtered_lines[${1}]}
	if [[ -n "$line_to_remove" ]]; then
		sudo sed -i "/${line_to_remove}/d" /etc/hosts
	fi
}
