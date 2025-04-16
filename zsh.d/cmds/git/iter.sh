desc="Iterate over a set of commits"
args=("--ref:Base ref to start iteration from")
help=("iter" "Iterate over a set of commits.

 Iterate over a set of scripts via 'git rebase'.
 Given a ref to start it the script issues a rebase which stops are all
 commits until the TIP is reached.

 When the script pauses the user can hit <ctrl-c> to cancel iteration,
 <ctrl-z> to access the terminal (to run an editor, perhaps), or any other key
 to continue iteration.

 This can be useful when reviewing a PR commit-by commit.
 With each commit checked out during the iteration all LSP and editor tools
 will work appropriately.
")

review_commit() {
	lib_info "Stopping to review commit:"
	git log -1 --format=short
	lib_info "Use ctrl-c to cancel iteration, ctrl-z to access terminal, any-key to continue iteration."
	read -r
}

execute() {
	export -f log
	export -f review_commit
	git rebase --exec="bash -c review_commit" "${ref}"
}


