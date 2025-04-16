desc="Configure a remote rocky server for development"
args=("--host:The remote host as an IP or hostname" \
	  "--user:The user to configure")
help=("rocky-linux", "Configure a remote rocky server for development.

 This script will configure the {user} on {host} via ssh, copy over the
 '.rocky-server-setup.sh' script, and execute it. This requires ssh'ing to
 {host} as the root user for bootstrapping.

 The '.rocky-server-setup.sh' script will install all components necessary for
 development and kernel building/development.")

execute() {
	eval $lib_eval_argparse

	lib_info "Configuring user ${user}..."
	ssh root@"${host}" "useradd ${user} || true && cp -r ~/.ssh /home/${user}/ && chown -R ${user}:${user} /home/${user}"
	ssh root@"${host}" "echo '${user} ALL=(ALL) ALL' >> /etc/sudoers"
	ssh root@"${host}" "passwd ${user}"

	scp $CMDS_DIR/automation/.rocky-server-setup.sh "${user}"@"${host}":/tmp/rocky-server-setup.sh
	ssh -t "${user}"@"${host}" "chmod +x /tmp/rocky-server-setup.sh && /tmp/rocky-server-setup.sh"
}

