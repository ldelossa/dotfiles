desc="Configure a remote fedora server for development"
args=("--host:The remote host as an IP or hostname" \
	  "--user:The user to configure")
help=("fedora-linux", "Configure a remote fedora 42 server for development.

 This script will configure the {user} on {host} via ssh, copy over the
 '.fedora-server-setup.sh' script, and execute it. This requires ssh'ing to
 {host} as the root user for bootstrapping.

 The 'fedora-server-setup.sh' script will install all components necessary for
 development and kernel building/development.")

execute() {
	lib_info "Configuring user ${user}..."
	ssh root@"${host}" "useradd ${user} || true && cp -r ~/.ssh /home/${user}/ && chown -R ${user}:${user} /home/${user}"
	ssh root@"${host}" "echo '${user} ALL=(ALL) ALL' >> /etc/sudoers"
	ssh root@"${host}" "passwd ${user}"

	scp $CMDS_DIR/automation/.fedora-42-server-setup.sh "${user}"@"${host}":/tmp/fedora-42-server-setup.sh
	ssh -t "${user}"@"${host}" "chmod +x /tmp/fedora-42-server-setup.sh && /tmp/fedora-42-server-setup.sh"
}
