desc="Given a kind docker container, nsenter the agent container and execute a shell"
args=("--container: Kind container name where agent pod is running")
help=("Given a kind docker container, nsenter the agent container and execute a shell

	In the case where Cilium is being ran in Kind, typically for local development,
	is common to want to directly open a shell into the Cilium agent pod running
	on the node.

	This command provides a shortcut to directly obtain a shell into the Cilium
	agent pod, but executing into the Kind container, finding the Cilium agent's
	pid, and using nsenter to enter all this pid's namespaces.

	Commands can be provided after the '--' argument to be explicit invoked in
	the agent container.

	If no commands are provided 'bash' is the default.
")

execute() {
	if [[ ${+container} == 0 ]]; then
		echo "Container name is required"
		exit 1
	fi
	nsenter='nsenter -a -t $(pgrep cilium-agent)'

	if [[ -z ${forwarded} ]]; then
		forwarded="bash"
	fi

	nsenter="${nsenter} ${forwarded}"
	echo $nsenter
	docker exec -it "$container" bash -c ${nsenter}
}
