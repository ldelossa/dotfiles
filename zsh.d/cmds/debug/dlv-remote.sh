desc="Connect to a remote dlv debugger"
args=("--remote:The remote address in host port syntax")
help=("dlv-remote" "Connect to a remote dlv debugger

 Provide a remote address in host:port syntax.
 E.g: '1.1.1.1:1234'
")

execute() {
	eval $lib_eval_argparse
	dlv connect "${remote}"
}
