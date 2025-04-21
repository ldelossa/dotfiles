lib_kubectl() {
	kubectl --namespace "$(cat $CMDS_DIR/k8s/.namespace)" \
			--context "$(cat $CMDS_DIR/k8s/.context)" \
			${@}
}
