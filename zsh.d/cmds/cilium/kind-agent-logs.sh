desc="Given a kind docker container, log the corresponding Cilium agent"
args=("--container: Kind container name where agent pod is running")
help=("kind-agent-logs", "Given a kind docker container, log the corresponding Cilium agent")

execute() {
	if [[ ${+container} == 0 ]]; then
		echo "Container name is required"
		exit 1
	fi
	agent=($(kubectl get pods -A -o json --field-selector spec.nodeName=cilium-testing-worker2 -l app.kubernetes.io/name=cilium-agent | jq -r ".items[0].metadata.name, .items[0].metadata.namespace"))
	kubectl --namespace "$agent[2]" logs --follow "$agent[1]"
}

