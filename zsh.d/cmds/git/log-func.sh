desc="Log changes to a function within a file over time"
args=("--file:The file to log" \
	  "--func:The function name to track")
help=("log-func" "Log changes to a function within a file over time")

execute() {
	git log -L:"${file}":"${func}"
}
