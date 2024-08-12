function virsh-tcp() {
	host="${1}"
	shift
	virsh -c qemu+tcp://"$host":16509/system "${@}"
}
