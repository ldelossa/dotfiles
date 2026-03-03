desc="Replace a hosts entry"
args=("--id: The entry to replace" \
	  "--host:[o]The host a name maps to" \
	  "--name:[o]The name of the host")
help=("replace" "Replace a hosts entry.
 Given an ID replace it with the provided host, name, or both.

 Providing neither a host or a name results in a no-op.
")

execute() {
	IFS=$'\n'

	entries=($(cat /etc/hosts))

	# no-op, nothing to replace!
	if [[ ${+host} == 0 ]] && [[ ${+name} == 0 ]]; then
		exit 0
	fi

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

	to_replace=${sanitized[$id]}
	new_host=$(echo $to_replace | awk '{print $1}')
	new_name=$(echo $to_replace | awk '{print $2}')

	if [[ ${+host} == 1 ]]; then
		new_host=$host
	fi

	if [[ ${+name} == 1 ]]; then
		new_name=$name
	fi

	# replace original to_replace line in file with new entry
	sudo sed -i "s|$to_replace|$new_host $new_name|g" /etc/hosts
}
