desc="A wrapper which calls kubectl with the stored context, namespace, and config"
args=()
help=("ctl" "A wrapper which calls kubectl with the stored context, namespace, and config

Use the "--" argument to forward commands directly to kubectl.
Example: cmds k8s kubectl -- get pods
")

source "$CMDS_DIR/k8s/.lib.sh"

execute() {
	lib_kubectl "${forwarded}"
}
