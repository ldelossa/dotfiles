desc="Create a netshoot deployment for network debuggin"
args=("--host_network:[b,o] join the host's network namespace" \
      "--destroy:[b,o] destroy the netshoot daemon set" \
      "--namespace:[o] an optional namespace to deploy to (default: kube-system")
help=("netshoot-container" " Creates a deployment of netshoot containers.
 Replica count is set to the number of hosts.

 The '--host-network' flag can be provided to join the host's network namespace.
 The '--destroy' flag will destroy an existing netshoot deployment, all other
 flags are ignored.
")

execute() {
	if [[ ${+host_network} == 0 ]]; then
		host_network=false
	fi

	if [[ ${+namespace} == 0 ]]; then
		namespace=kube-system
	fi

	if [[ ${+destroy} == 1  ]]; then
		kubectl --namespace="$namespace" delete deployment netshoot-debug
		return
	fi

	node_n=$(kubectl get nodes -o name | wc -l)

	# this needs to be spaced exactly like yaml
	template="apiVersion: apps/v1
kind: Deployment
metadata:
  name: netshoot-debug
spec:
  selector:
    matchLabels:
      app: netshoot-debug
  replicas: $node_n
  template:
    metadata:
      labels:
        app: netshoot-debug
    spec:
      tolerations:
        - key: 'node-role.kubernetes.io/control-plane'
          operator: 'Exists'
          effect: 'NoSchedule'
      volumes:
        - name: kind-mount
          hostPath:
            path: '/mnt'
      hostNetwork: $host_network
      containers:
      - name: netshoot
        image: nicolaka/netshoot:latest
        command: ['sleep', 'infinite']
        volumeMounts:
          - mountPath: /mnt
            name: kind-mount"

	kubectl --namespace="$namespace" apply -f <(echo "$template")
}
