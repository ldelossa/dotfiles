desc="Create a local kernel config from current mods"
args=()
help=("mod-config-local", "Create a local kernel config from current mods

 This command will create a listing of the local machine's modules and write
 it to /tmp/lsmod.now.

 Given your shell's current working directory is a Kernel source repository,
 a new config will be made only enabling the same modules defined in lsmod.now.
 ")


execute() {
	lsmod > /tmp/lsmod.now
	yes "" | make LSMOD=/tmp/lsmod.now localmodconfig
}
