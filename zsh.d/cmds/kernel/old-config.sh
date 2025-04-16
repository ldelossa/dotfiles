desc="Create a kernel config based on an old one"
args=("--host:The remote development host"\
	  "--user:The user to perform actions as")
help=("old-config", "Create a kernel config based on an old one

 Given the shell's working directory is a Linux kernel source repository this
 script with push the directory to the remote, copy the remote's running kernel
 config to the pushed kernel source directory, create a new config via
 'make olddefconfig' and sync the repository back to the host
 ")

execute() {
	set -e

	ssh_host="${user}@${host}"

	# push local repository to remote.
	lib_info "Pushing local repository to remote..."
	ssh "${ssh_host}" "mkdir -p $(pwd) || true"

	rsync -e ssh --delete --exclude '.git' -azv "$(pwd)"/ ${ssh_host}:"$(pwd)"

	lib_info "Copying existing config file to local repository..."
	ssh "${ssh_host}" "cd $(pwd) && cp /boot/config-\$(uname -r) .config"

	log "Making new config..."
	ssh "${ssh_host}" "cd $(pwd) && yes '' | make olddefconfig"

	lib_info "Applying common configuration edits"
	# 1. don't randomize address spaces making the kernel a bit easier to debug
	# 2. delete the trusted keys for signing, forcing `make install` to prompt us
	#    for the desired value (usually blank string).
	ssh ${ssh_host} "cd $(pwd) && \
					 sed -i 's/^\\(CONFIG_RANDOMIZE_BASE\\)=y/# \\1 is not set/' .config && \
					 sed -i '/^CONFIG_SYSTEM_TRUSTED_KEYS=.*$/d' .config"

	lib_info "Syncing remote repository to local..."
	rsync -e ssh --delete -azv "${ssh_host}":"$(pwd)"/ "$(pwd)"/
}

