desc="Connect to a remote lldb debugger"
args=("--remote:The remote address in host port syntax")
help=("gdb-remote" "Connect to a remote lldb debugger

 Provide a remote address in host:port syntax.
 E.g: '1.1.1.1:1234'
")

execute() {
	eval $lib_eval_argparse
	lldb -o "gdb-remote ${remote}"
}

