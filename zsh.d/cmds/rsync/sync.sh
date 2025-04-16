desc="Copy the given file or directory to a remote node"
args=("--remote:The remote host in ssh format" \
	  "--from:The local file system path" \
	  "--to:[o] The remote file system path")
help=("cp" "Copy the given file or directory to a remote node

 The 'to' argument is optional.
 If ommitted the file will be copied to the same location on the remote,
 creating any necessary parent paths.
")

execute() {
	if [[ ${+to} -eq 0 ]]; then
		to="${from}"
	fi
	rsync -avz --progress -e ssh "$from" "$remote":"$to"
}
