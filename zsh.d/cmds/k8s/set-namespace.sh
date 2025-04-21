desc="Set the namespace for all k8s commands"
args=("--namespace:The namespace to set")
help=("set-namespace" "Set the namespace for all k8s commands

 This script writes to .namespace file in the same directory.
 All further k8s scripts will use this namespace until changed.


 If --namespace flag is not specified the current namespace is
 displayed.
 ")

 execute() {
	 if [[ ${+namespace} -eq 0 ]]; then
		 cat "$CMDS_DIR/k8s/.namespace"
		 return
	 fi
	 echo -n "$namespace" > "$CMDS_DIR/k8s/.namespace"
 }
