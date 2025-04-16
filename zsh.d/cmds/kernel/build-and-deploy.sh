desc="Build and deploy a local Kernel to a remote machine"
args=("--host:The remote Kernel development host" \
	  "--user:The user to perform the build as" \
	  "--reboot:[o,b]:Reboot the remote development host")
help=("build-and-deploy", "Build and deploy a local Kernel to a remote machine

 This script should be ran from within a Kernel source code repository.

 The script will push the code to the remote, build it (along with libbpf,
 bpftool, and other helpful in-tree programs/libraries), install it, and
 optionally restart the remote development host.

 The source code is sync'd back to the host.
 This is useful since the vmlinuz image can be used for remote debugging
 purposes.

 The 'user' flag is used to 'reset' all file permissions within the kernel
 repository since the build process can overwrite these permissions to the
 root user at times. This ensures all files sync'd back to the host can be
 accessed correctly.
 ")

execute() {
	# stop if errors
	set -e

	root="root"
	ssh_host="${user}@${host}"
	root_ssh_host="${root}@${host}"
	repo=$(pwd)

	# push local repository to remote.
	lib_info "Pushing local repository to remote..."
	ssh "${ssh_host}" "mkdir -p $repo || true"
	rsync -e ssh --delete --exclude '.git' -azv "$repo"/ "${ssh_host}":"$repo"

	lib_info "Building the remote kernel..."
	ssh "${ssh_host}" "cd $repo && make -j \$((\$(nproc)*2)) && make tools/lib/bpf && make tools/bpf/bpftool && ./scripts/clang-tools/gen_compile_commands.py"

	lib_info "Installing the remote Kernel..."
	ssh "${root_ssh_host}" "cd $repo && make modules_install && make install"

	lib_info "Installing libbpf from kernel tree..."
	# make the library
	ssh "${ssh_host}" "cd $repo/tools/lib/bpf && make"
	# backup any existing libbpf libraries
	ssh "${root_ssh_host}" "mv /usr/lib64/libbpf* /tmp || true"
	# install libbpf to /usr/lib64 (fedora specific)
	ssh "${root_ssh_host}" "cd $repo/tools/lib/bpf && make prefix=/usr install && cp libbpf.so* /usr/lib64/ && chown -R ${user}:${user} ."

	lib_info "Installing bpftool from kernel tree..."
	ssh "${root_ssh_host}" "cd $repo/tools/bpf/bpftool && make install && chown -R ${user}:${user} ."

	lib_info "Resetting all file perms to user..."
	ssh "${root_ssh_host}" "cd $repo && chown -R ${user}:${user} ."

	lib_info "Syncing built kernel locally..."
	rsync -e ssh --delete --exclude '.git' -azv "${ssh_host}":"$repo"/ "$repo"/

	if [[ -n $reboot ]]; then
		lib_info "Install complete, rebooting the host..."
		ssh "${root_ssh_host}" "reboot"
	else
		lib_info "Install complete, reboot the host to enter new kernel..."
	fi
}

