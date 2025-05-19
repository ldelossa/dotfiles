desc="Create a kubectl debug container"
args=("--image:[o] The image to use (default: nicolaka/netshoot:latest)" \
      "--container: The container to debug" \
	  "--namespace:[o] The namespace of the container to debug")
help=("netshoot-container" " Create a kubectl debug container.

")

execute() {

	if [[ ${+name} == 0 ]]; then
		name="debugger"
	fi

	if [[ ${+image} == 0 ]]; then
		image="nicolaka/netshoot"
	fi

	if [[ ${+namespace} == 0 ]]; then
		namespace="kube-system"
	fi

	kubectl debug -it -n "$namespace" "$container" --image "$image" --image-pull-policy=Always
}
