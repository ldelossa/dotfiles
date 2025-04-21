desc="Set the context for all k8s commands"
args=("--context:[o]The context to set")
help=("set-context" "Set the context for all k8s commands

 This script writes to .context file in the same directory.
 All further k8s scripts will use this context until changed.

 If --context flag is not specified the current context is
 displayed.
 ")

 execute() {
	 if [[ ${+context} -eq 0 ]]; then
		 cat "$CMDS_DIR/k8s/.context"
		 return
	 fi
	 echo -n "$context" > "$CMDS_DIR/k8s/.context"
 }
