#compdef cmds

source ~/zsh.d/cmds/.lib.sh

CMDS_PARENT_DIR=~/zsh.d
CMDS_ROOT_DIR=cmds
CMDS_DIR=$CMDS_PARENT_DIR/$CMDS_ROOT_DIR

_cmds_completion() {
	# convert $BUFFER into a relative path, replacing spaces with '/'
	# this completion functions will always have 'cmds/' as its first path
	# parameter since its the shell script that is being completed.
	BUFFER_PATH=${BUFFER// /\/}
	# BUFFER_PATH may include arguments at this point, for example
	# x/y/z/--one/--two/--three. We want to remove everything from the first
	# /-* to the end.
	BUFFER_PATH="${BUFFER_PATH%%/-*}"
	# fully qualify BUFFER_PATH and remove trailing slash, remember $BUFFER_PATH
	# is derived from the command line input which already has `cmds/` as the
	# first parameter.
	BUFFER_PATH=${CMDS_PARENT_DIR}/${BUFFER_PATH%/}
	# the final command being invoked on the cli.
	# for example /x/y/z
	#                  ^
	CMD=$(basename "$BUFFER_PATH")
	# the path toward (but not consisting of) the final command being invoked
	# on the cli.
	# for example /x/y/z
	# 			  |---|
	CMD_PATH=$(dirname "$BUFFER_PATH")

	# if our command is the root shell function we want to list directories
	# and files at the root of $CMDS_PATH
	if [[ "$CMD" == "cmds" ]]; then
		compadd -- $(ls $CMDS_DIR)
		return
	fi

	# Lets check if the provided BUFFER_PATH points to a directory or file.
	# If it points to a directory, we provide the listing of this directory
	# as futher completion. If it points to a file we can provide the script's
	# completion arguments.
	if [[ -e "$BUFFER_PATH" ]]; then
		# if its a directory, we want to list the files in it
		if [[ -d "$BUFFER_PATH" ]]; then
			compadd -- $(ls $BUFFER_PATH)
			return
		fi

		# if its a file, its a command, source in any arguments for completion
		if [[ -f "$BUFFER_PATH" ]]; then
			source $BUFFER_PATH
			local -a a
			a=("${args[@]}")

			# we always add a help command to script writers do not need to
			# remember to add it to their script.
			a+=("--help:[b,o] Display help")

			_describe 'command' a
			return
		fi
	fi

	# BUFFER_PATH does not point to a real directory/file, this means either
	# 1. its garbage
	# 2. its a partial completion
	# In any case, if the parent path of our BUFFER_PATH is legit, we can provide
	# the listing
	if [[ -d $CMD_PATH ]]; then
		compadd -- $(ls $CMD_PATH)
		return
	fi
}

compdef _cmds_completion cmds

cmds() {
(
	# build path until any arguments are discovered
	local CMD_BUFFER=$CMDS_DIR
	for arg in $@; do
		# parse our command until we come across an argument
		if [[ "$arg" == "-"* ]]; then
			break
		fi
		CMD_BUFFER="$CMD_BUFFER/$arg"
		shift
	done

	# if its a directory source and print .description
	if [[ -d $CMD_BUFFER ]]; then
		# source the description file and print $desc variable
		source $CMD_BUFFER/.description
		lib_describe $desc $CMD_BUFFER
		return
	fi

	# if its a regualr file, execute it
	if [[ -f $CMD_BUFFER ]]; then
		source $CMD_BUFFER
		execute "$@"
		return
	fi
)
}
