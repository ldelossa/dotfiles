desc="Block pushes to a set of remotes, per-branch."
args=("--list:[b,o] list all branches and their allowed lists" \
	  "--add:[b,o] add a remote to a branch's allowed list, must be followed with --branch and --remote" \
      "--remove:[b,o] remove a remote from a branch's allowed list, must be followed with --branch and --remote" \
      "--branch:[o] specify the branch to modify, used with --add and --remove" \
	  "--remote:[o] specify the remote to add or remove, used with --add")
help=("push-allow-list" "Block pushes to a set of remotes, per-branch.

 Provide an allow list for a particular branch, constraining which remotes the
 branch is allowed to be pushed to.

 --list will list all branches which have allow lists, followed by the remotes
 that are allowed.

 --add will add a remote to the current branch's allowed list

 --remove will remove a remote to the current branch's allowed list

")

# Keys are stored as: allowlist.<branch>.remote = <name>
# The branch is a git config subsection (quoted in the config file), so it
# tolerates slashes, dots, and other characters that aren't legal in a
# variable name.
function list() {
	git config --local --get-regexp '^allowlist\..*\.remote$' \
		| sed 's/^allowlist\.\(.*\)\.remote \(.*\)$/\1 \2/' \
		| sort
}

function add() {
	branch=$1
	remote=$2
	# no-op if already present, to keep --get-all output dup-free
	if git config --local --get-all allowlist."$branch".remote 2>/dev/null \
		| grep -Fxq -- "$remote"; then
		return 0
	fi
	git config --local --add allowlist."$branch".remote "$remote"
}

function remove() {
	branch=$1
	remote=$2
	git config --local --fixed-value --unset-all allowlist."$branch".remote "$remote"
}

execute() {
	cmd=""
	if [[ ${+list} == 1 ]]; then
		cmd="list"
	elif [[ ${+add} == 1 ]]; then
		cmd="add"

		# must contain a branch and remote
		if [[ -z $branch ]]; then
			echo "--add must be used with --branch."
			exit 1
		fi

		if [[ -z $remote ]]; then
			echo "--add must be used with --remote."
			exit 1
		fi

	elif [[ ${+remove} == 1 ]]; then
		cmd="remove"

		# must contain a branch and remote
		if [[ -z $branch ]]; then
			echo "--remove must be used with --branch."
			exit 1
		fi

		if [[ -z $remote ]]; then
			echo "--remove must be used with --remote."
			exit 1
		fi
	else
		echo "One of --list, --add, or --remove must be used."
		exit 1
	fi

	if [[ $cmd == "list" ]]; then
		list
	elif [[ $cmd == "add" ]]; then
		add "$branch" "$remote"
	elif [[ $cmd == "remove" ]]; then
		remove "$branch" "$remote"
	fi

}



