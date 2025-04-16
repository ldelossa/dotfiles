desc="Create a kernel config from current mods"
args=("--host:The remote development host"\
	  "--user:The user to perform actions as")
help=("mod-config", "Create a kernel config from current mods

 This command will create a listing of the local machine's modules and write
 it to /tmp/lsmod.now.

 Given your shell's current working directory is a Kernel source repository,
 the repository will be pushed to the remote development server, the currently
 enabled modules are written to /tmp/lsmod.now on the remote, and a config 
 is generated based on these.

 Finally, the source is sync'd back to the host.
 ")

execute() {
	ssh_host="${user}@${host}"
	repo=$(pwd)

	# push local repository to remote.
	lib_info "Pushing local repository to remote..."
	ssh "${ssh_host}" "mkdir -p $repo || true"
	rsync -e ssh --delete --exclude '.git' -azv "$repo"/ "${ssh_host}":"$repo"

	lib_info "Creating config based on current modules"
	ssh "${ssh_host}" "cd $repo && lsmod > mods.now && yes '' | make LSMOD=mods.now localmodconfig"

	log "Applying common configuration edits"
	# 1. don't randomize address spaces making the kernel a bit easier to debug
	# 2. delete the trusted keys for signing, forcing `make install` to prompt us
	#    for the desired value (usually blank string).
	ssh ${ssh_host} "cd $(pwd) && \
					 sed -i 's/^\\(CONFIG_RANDOMIZE_BASE\\)=y/# \\1 is not set/' .config && \
					 sed -i '/^CONFIG_SYSTEM_TRUSTED_KEYS=.*$/d' .config"

	lib_info "Syncing remote repository to local..."
	rsync -e ssh --delete -azv "${ssh_host}":"$repo"/ "$repo"/
}


