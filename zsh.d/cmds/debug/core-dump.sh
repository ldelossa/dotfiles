desc="Open the last coredump in a debugger"
args=()
help=("core-dump" "Open the last coredump in a debugger (lldb)
")

execute() {
	debugger="lldb"
	coredumpctl debug --no-pager --debugger=${debugger}
}
