desc="Connect to a remote gdb debugger"
args=("--remote:The remote address in host port syntax")
help=("gdb-remote" "Connect to a remote gdb debugger

 Provide a remote address in host:port syntax.
 E.g: '1.1.1.1:1234'
")

execute() {
	eval $lib_eval_argparse
	gdb -iex "target remote ${remote}"
}

