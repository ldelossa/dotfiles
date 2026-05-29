desc="Block pushes to a set of remotes, per-branch."
args=("--list:[b,o] list all branches and their allowed lists" \
	  "--add:[b,o] add a remote to a branch's allowed list, must be followed with --remote (--branch defaults to the current branch)" \
      "--remove:[b,o] remove a remote from a branch's allowed list, must be followed with --remote (--branch defaults to the current branch)" \
      "--clean:[b,o] remove allow list entries whose branch or remote no longer exists, after confirming" \
      "--branch:[o] specify the branch to modify, used with --add and --remove (defaults to the current branch)" \
	  "--remote:[o] specify the remote to add or remove, used with --add")
help=("push-allow-list" "Block pushes to a set of remotes, per-branch.

 Provide an allow list for a particular branch, constraining which remotes the
 branch is allowed to be pushed to.

 --list will list all branches which have allow lists, followed by the remotes
 that are allowed.

 --add will add a remote to the current branch's allowed list

 --remove will remove a remote to the current branch's allowed list

 --clean removes any allow list entry whose branch is no longer present
 locally or whose remote no longer exists. The entries that would be removed
 are printed first and the user must type Y to confirm.

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

function current_branch() {
	git symbolic-ref --quiet --short HEAD
}

function clean() {
	local -a stale_branches=()
	local -a stale_remotes=()
	local entry b r
	while IFS= read -r entry; do
		[[ -z $entry ]] && continue
		b="${entry% *}"
		r="${entry##* }"
		if ! git show-ref --verify --quiet "refs/heads/$b"; then
			stale_branches+=("$b $r")
		elif ! git remote get-url "$r" >/dev/null 2>&1; then
			stale_remotes+=("$b $r")
		fi
	done < <(list)

	if [[ ${#stale_branches[@]} -eq 0 && ${#stale_remotes[@]} -eq 0 ]]; then
		echo "No stale allow list entries found."
		return 0
	fi

	echo "The following allow list entries would be removed:"
	for entry in "${stale_branches[@]}"; do
		echo "  $entry (branch missing)"
	done
	for entry in "${stale_remotes[@]}"; do
		echo "  $entry (remote missing)"
	done

	local reply
	read -r "reply?Type Y to confirm: "
	if [[ $reply != "Y" ]]; then
		echo "Aborted."
		return 1
	fi

	for entry in "${stale_branches[@]}" "${stale_remotes[@]}"; do
		b="${entry% *}"
		r="${entry##* }"
		remove "$b" "$r"
	done
}

execute() {
	cmd=""
	if [[ ${+list} == 1 ]]; then
		cmd="list"
	elif [[ ${+clean} == 1 ]]; then
		cmd="clean"
	elif [[ ${+add} == 1 ]]; then
		cmd="add"

		if [[ -z $branch ]]; then
			branch=$(current_branch)
			if [[ -z $branch ]]; then
				echo "--add: could not resolve current branch, pass --branch explicitly."
				exit 1
			fi
		fi

		if [[ -z $remote ]]; then
			echo "--add must be used with --remote."
			exit 1
		fi

	elif [[ ${+remove} == 1 ]]; then
		cmd="remove"

		if [[ -z $branch ]]; then
			branch=$(current_branch)
			if [[ -z $branch ]]; then
				echo "--remove: could not resolve current branch, pass --branch explicitly."
				exit 1
			fi
		fi

		if [[ -z $remote ]]; then
			echo "--remove must be used with --remote."
			exit 1
		fi
	else
		echo "One of --list, --add, --remove, or --clean must be used."
		exit 1
	fi

	if [[ $cmd == "list" ]]; then
		list
	elif [[ $cmd == "clean" ]]; then
		clean
	elif [[ $cmd == "add" ]]; then
		add "$branch" "$remote"
	elif [[ $cmd == "remove" ]]; then
		remove "$branch" "$remote"
	fi

}



