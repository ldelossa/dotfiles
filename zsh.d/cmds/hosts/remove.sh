desc="Remove an entry from the hosts file"
args=("--id:ID of hosts file entry returned from list command" \
	  "--help:[b,o] Display help")
help=("remove" "Remove an entry from the hosts file")

execute() {
	eval $lib_eval_argparse

	IFS=$'\n'

	entries=($(cat /etc/hosts))

	sanitized=()

	for entry in "${entries[@]}"; do
		if [[ -z $entry ]]; then
			continue
		fi
		if [[ ${entry:0:1} == "#" ]]; then
			continue
		fi
		sanitized+=("$entry")
	done

	to_delete=${sanitized[$id]}

	# remove the line in the /etc/hosts file which matches exactly with
	# to_delete variable
	sudo sed -i "/$to_delete/d" /etc/hosts
}
