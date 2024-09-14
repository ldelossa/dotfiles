#!/bin/bash

function set-devbox() {
	# number of args must be 2
	if [ $# -ne 2 ]; then
		echo "Usage: set-devbox <index> <hostname>"
		return 1
	fi

	index=${1}
	hostname=${2}

	mkdir -p ~/.config/devbox/ || true

	echo -n "$hostname" > ~/.config/devbox/"${index}"-devbox
}

function list-devbox() {
	for x in ~/.config/devbox/*; do
		echo "$(basename "${x%-devbox}") $(cat "$x")"
	done
}

function get-devbox() {
	# number of args must be 1
	if [ $# -ne 1 ]; then
		echo "Usage: get_devbox <index>"
		return 1
	fi

	index=${1}
	cat ~/.config/devbox/"${index}"-devbox
}

function rm-devbox() {
	# number of args must be 1
	if [ $# -ne 1 ]; then
		echo "Usage: get_devbox <index>"
		return 1
	fi

	index=${1}
	rm -f ~/.config/devbox/"${index}"-devbox
}

function launch-devbox() {
	# number of args must be 2
	if [ $# -ne 2 ]; then
		echo "Usage: set-devbox <index> <et|ssh|mosh>"
		return 1
	fi

	index=${1}
	protocol=${2}

	# validate protocol types
	if [ "$protocol" != "et" ] && [ "$protocol" != "ssh" ] && [ "$protocol" != "mosh" ]; then
		echo "Usage: set-devbox <index> <hostname> <et|ssh|mosh>"
		return 1
	fi

	$protocol "$(get-devbox "$index")"
}
