# the trickiest part of .lib.sh is that it runs after we sourced the script
# being executed into our shell.
#
# this means variables the script exports are available to us.
# these special variables are:
# $desc - a short single line description displayed in a subcommand's help
# $args - an array of arguments in zsh's _describe syntax
# $help - an array consiting of the the script name as the first element and
#         a long form description of how the command is used.
#
# scripts MUST define these variables, even if no args are used in the script.
# if no args are used simply provide an empty array 'args=()'.

# error logger with red
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

# describes a subcommand and its commands.
# $1: summary string describing subcommand
# $2: subcommand directory
lib_describe() {
	# list subcommand's commands or further nested subcommands, source each
	# one to get the desc variable and append it to our listing of commands.
	local -a cmds=()
	for p in $(ls $2); do
		source $2/$p
		cmds+=("$p\t$desc\n")
	done

	#here doc with interpolation to print description
	cat <<EOF
SUMMARY:
  $1

COMMANDS:
$(for cmd in $cmds; do
	echo "  $cmd"
done | column -t -s $'\t')
EOF
}

lib_help() {
	cat <<EOF

Usage: $1 [options]

Options:
$(for arg in $args; do
  echo "  "${arg%:*}'\t'${arg#*:}
done | column -t -s $'\t')

Description:
 $(echo -e $2)
EOF
}

lib_print_help_and_exit() {
	lib_help "${help[1]}" "${help[2]}"
	exit
}

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
					echo "ERROR: miss value for flag ${r_args[i]}"
					return 1
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
lib_eval_argument_parse='lib_argument_parse "${@}"'
