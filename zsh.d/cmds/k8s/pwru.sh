desc="Start a PWRU container on all nodes to trace kernel networking"
args=("--destroy:[b,o] destroy the netshoot daemon set" \
      "--namespace:[o] an optional namespace to deploy to (default: kube-system")
help=("pwru" "Start a PWRU container on all nodes to trace kernel networking")

execute() {
	if [[ ${+namespace} == 0 ]]; then
		namespace=kube-system
	fi

	if [[ ${+destroy} == 1  ]]; then
		kubectl --namespace="$namespace" delete deployment pwru-debug
		return
	fi

	node_n=$(kubectl get nodes -o name | wc -l)

	# this needs to be spaced exactly like yaml
	template="apiVersion: apps/v1
kind: Deployment
metadata:
  name: pwru-debug
spec:
  selector:
    matchLabels:
      app: pwru-debug
  replicas: $node_n
  template:
    metadata:
      labels:
        app: pwru-debug
    spec:
      tolerations:
        - key: 'node-role.kubernetes.io/control-plane'
          operator: 'Exists'
          effect: 'NoSchedule'
      volumes:
        - name: kind-mount
          hostPath:
            path: '/mnt'
        - name: sys-kernel-debug
          hostPath:
            path: '/sys/kernel/debug'
      hostNetwork: true
      hostPID: true
      containers:
      - name: pwru
        image: cilium/pwru:latest
        command: ['sleep', 'infinite']
        securityContext:
          privileged: true
        volumeMounts:
          - mountPath: /mnt
            name: kind-mount
          - mountPath: /sys/kernel/debug
            name: sys-kernel-debug"

	kubectl --namespace="$namespace" apply -f <(echo "$template")
}
