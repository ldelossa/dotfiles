desc="Add an entry to the hosts file"
args=("--host:The host a name maps to" \
	  "--name:The name of the host")
help=("add" "Add an entry to the hosts file")

execute() {
	eval $lib_eval_argument_parse
	printf "%s %s\n" "$host" "$name" | sudo tee -a /etc/hosts
}
