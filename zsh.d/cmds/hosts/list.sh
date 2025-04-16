desc="List hosts file entries."
args=()
help=("list" "List hosts file entires.

 Each listing is prefixed with an ID that can be used to add or remove entries.")

execute() {
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

	for ((i=0; i<${#sanitized[@]}; i++)); do
		echo "$i: ${sanitized[$i]}"
	done
}
