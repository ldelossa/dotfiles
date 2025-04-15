#compdef cmds

# .lib.sh is the entry point which loads the cmds/ framework into your shell it
# defines all framework variables and functions available to both your
# interactive shell and scripts which are involved via the cmds function.
#
# when the 'cmds' function is invoked it will launch a subshell which then
# sources the desired script.
# this means that all global variables in .lib.sh are available when writing
# scripts with no need to source .lib.sh from the script.
#
# similarly, all variables from the script are available within .lib.sh.
# this can be a bit confusing since functions in this file reference key
# variables defined in scripts.
# these special variables are:
# $desc - a short single line description displayed in a subcommand's help
# $args - an array of arguments in zsh's _describe syntax and a bit of our own
# 		  argument options syntax (see lib_argument_parse)
# $help - an array consiting of the the script name as the first element and
#         a long form description of how the command is used.
#
# scripts MUST define these variables, even if no args are used in the script.
# if no args are used simply provide an empty array 'args=()'.

#############
# VARIABLES #
#############

# points to the parent directory where the cmds/ framework directory resides.
# evaluated on source
CMDS_PARENT_DIR=$(dirname $(dirname $(realpath $0)))
# evaluated on source
# the name of the cmds/ framework directory
#
# NOTE: if you change this to a different directory you must also update the
# name of the command runner function.
#
# this is because the path of least resistance is to use the function name as
# the first path directory toward the target script.
# for example "cmds my-subcommand my-command" is converted to the relative path
# cmds/my-subcommand/my-command by the command runner and zsh completion code.
CMDS_ROOT_DIR=cmds
# full path to the cmds/ framework directory
CMDS_DIR=$CMDS_PARENT_DIR/$CMDS_ROOT_DIR

###########
# LOGGING #
###########
lib_error() {
	local red='\033[0;31m'
	local reset='\033[0m'
	echo -e "${red}$1${reset} "
}

lib_info() {
	local blue='\033[0;34m'
	local reset='\033[0m'
	echo -e "${blue}$1${reset} "
}

lib_warning() {
	local yellow='\033[0;33m'
	local reset='\033[0m'
	echo -e "${yellow}$1${reset} "
}

##################
# OUTPUT HELPERS #
##################

# outputs a well-defined description of a sub-command.
# $1: summary string describing subcommand
# $2: subcommand directory
lib_describe() {
	# grab each subcommad's descriptions by sourcing each script and reading
	# the $desc variable.
	summary="$1"
	dir="$2"
	local -a cmds=()
	for f in $(ls $dir); do
		if [[ -d $dir/$f ]]; then
			source $dir/$f/.description
		else
			source $dir/$f
		fi
		cmds+=("$f\t$desc\n")
	done

	cat <<EOF
SUMMARY:
  $summary

COMMANDS:
$(for cmd in $cmds; do
	echo "  $cmd"
done | column -t -s $'\t')
EOF
}

# outputs a well defined help dialogue.
# $1 script name
# $2 long description of script's usage
lib_help() {
	script_name="$1"
	desc="$2"

	cat <<EOF

Usage: $script_name [options]

Options:
$(for arg in $args; do
  echo "  "${arg%:*}'\t'${arg#*:}
done | column -t -s $'\t')

Description:
 $(echo -e $desc)
EOF
}

# outputs a well defined help dialogue and exits the shell.
lib_print_help_and_exit() {
	lib_help "${help[1]}" "${help[2]}"
	exit
}

###############
# ARG PARSING #
###############

# parses the runtime args ($r_args) into the desired args exported by the script
# ($args). ($args) are in zsh's _describe syntax and also have argument options
# within '[]', these are a construct of our framework
#
# the parser works through $args and finds matching $r_arg(s), when it does it
# creates a global variable accessible from the running script. If one or more
# required arguments are not found an error message is shown, the help dialogue
# is displayed, and the shell session is exited.
#
# therefore, when a script runs or evaluates this function it can expect global
# variables to exist for each of its required arguments listed in $args.
#
# the cmds framework automatically adds the --help argument for any script, so
# the script author does not need to tediously write this argument.
# if this flag is discovered the parser will short-circuit, displaying the help
# and then exiting.
#
# therefore, the script can simply `eval $lib_eval_argument_parse` to handle
# all framework needs of parsing arguments, handling missing arguments, and
# printing help (regardless of any other arguments on the cli).
lib_argument_parse() {
	local r_args=("$@")

	local -a unset

	# do an initial check to see if --help or -h exist in the runtime args
	# if so we'll just print help and exit
	for r_arg in "${r_args[@]}"; do
		if [[ "$r_arg" == "-h" || "$r_arg" == "--help" ]]; then
			# remember, script's dont need to export it, so ensure its there
			# when we go to print all options and exit.
			args+=("--help:[b,o] Display help")
			lib_print_help_and_exit
		fi
	done

	# iterate over arguments our script wants and see if the runtime arguments
	# are provided.
	for arg in "${args[@]}"; do
		local found=false
		local is_optional=false
		local is_bool=false

		# remove description from _describe argument spec, extracting
		# the argument name. E.g: --c:[b,o]description for c command =>
		# --c
		local e_arg="${arg/:*/}"
		# extract the argument options in the description
		# these are
		# [x,y]
		#  ^ ^
		#  | |__o=optional
		#  |____b=boolean
		# when no options are specified the argument is, by default,
		# a required value type.
		local arg_opts="${${arg#*\[}%\]*}"

		if [[ $arg_opts == "$arg" ]]; then
			# this is the case when no [] is within the argument provided
			# by the script, the parameter expansion above 'defaults' to
			# just returning the original string if no modification was
			# made.
			#
			# unset arg_opts to ensure no checks below occur
			arg_opts=""
		fi

		# if the argument exported from the script is optional, store this
		# fact, we'll use it later for validation.
		if [[ $arg_opts == *"o"* ]]; then
			is_optional=true
		fi

		# iterate over runtime arguments searching for the script's exported
		# argument.
		#
		# if found, declare a global variable with the same name as the flag
		# sans the "--" prefix.
		for ((i=1; i <= ${#r_args[@]}; i++)); do
			r_arg="${r_args[i]}"

			if [[ "$r_arg" != "$e_arg" ]]; then
				continue
			fi

			# if argument is a boolean set a flag telling us how to shift the
			# runtime args array later.
			if [[ $arg_opts == *"b"* ]]; then
				is_bool=true
			fi

			# both our runtime arg and our extracted arg have '--' prefix
			# so remove this and store it as our global variable name,
			# converting the --flag to a global variable $flag
			local var_name="${e_arg#--}"

			# if its a boolean argument just declare a variable with true
			if [[ $is_bool == true ]]; then
				eval "$var_name=true"
			else
				# use a expansion trick to determine if next value another
				# flag.
				#
				# attempt to remove the "--" from the next argument.
				# if it was a flag, the "--" will will be removed and the
				# expanded string will not be equal the original. if it was a
				# value, no "--" is removed and an equivalent string is produced.
				#
				# the final -z check just ensures if the r_args[i+1] goes over
				# the array bounds we handle it.
				if [[ ${r_args[i+1]#--} != "${r_args[i+1]}" ]] ||
				   [[ -z ${r_args[i+1]} ]]; then
					lib_error "ERROR: missing value for flag ${r_args[i]}"
					lib_print_help_and_exit
				fi
				eval "$var_name=${r_args[i+1]}"
			fi

			found=true
			break
		done

		# if we didn't find the desired flag and its not optional add it to
		# our unset array, we'll log it out at the end.
		if [[ $found == false ]] && [[ $is_optional == false ]]; then
			local var_name="${e_arg#--}"
			if [[ ${(P)+var_name} -eq 0 ]]; then
				unset+=("$arg")
			fi
		fi
	done

	# if any unset flags list them and return an exit code
	if [[ ${#unset[@]} -gt 0 ]]; then
		lib_error "ERROR: The following required arguments were not provided:"
		for arg in "${unset[@]}"; do
			lib_error "${arg%:*} -- ${arg#*:}"
		done
		lib_print_help_and_exit
	fi
	return 0
}

# scripts can eval this variable to perform argument parsing.
lib_eval_argparse='lib_argument_parse "${@}"'

##################
# ZSH COMPLETION #
##################

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

##############
# CMD RUNNER #
##############

# cmds is the actual command runner.
# this is a function which gets sourced into the interactive shell.
# it will take a command line, convert it into a file system path and arguments
# and call the respective script with the provided arguments.
#
# this all occurs in a sub-shell so any environment modifications are thrown
# away when the command finishes.
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
