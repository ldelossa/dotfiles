desc="Log changes over a range of lines"
args=("--file:The file to log" \
	  "--start:The start line as a number" \
      "--end:The end line as a number")
help=("log-range" "Log changes over a range of lines")

execute() {
	git log -L "${file}","${start}":"${end}"
}

