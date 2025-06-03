desc="Run a command for each pod identified by a label"
args=("--label:The image to use (default: nicolaka/netshoot:latest)" \
	  "--namespace:[o] The namespace to search for the pods (default: kube-system)"
	 )
help=("for-each-pod" " Run a command for a set of pods which share a label.

 This command will search for pods that match the given label string.

 The command to run is provided after the forwarding argument '--'.
 For example:
	 cmds k8s for-each-pod.sh --label name=pod -- ls -la /tmp
")

execute() {

	if [[ ${+namespace} == 0 ]]; then
		namespace=kube-system
	fi

	pods=($(kubectl --namespace $namespace get pods -l $label -o custom-columns=NAME:.metadata.name --no-headers))

	if [[ -z "$pods" ]]; then
		echo "No pods found with label '$label' in namespace '$namespace'."
		return 1
	fi

	for pod in $pods; do
		lib_info "POD: $pod CMD: \"${forwarded}\""
		kubectl --namespace $namespace exec "$pod" -- ${forwarded[@]}
	done
}
