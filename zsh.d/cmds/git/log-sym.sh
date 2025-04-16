desc="Log changes to a symbol over time"
args=("--symbol:The symbol to log changes for")
help=("log-sym" "Log changes to a symbol over time")

execute() {
	git log -S "${symbol}"
}

