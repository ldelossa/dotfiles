desc="Determine if a ref is reachable from HEAD"
args=("--ref:ref to query for"
      "--head:[o] head ref to start query from, defaults to HEAD")
help=("reachable" "Determine if a ref is reachable from HEAD.

	Determine if a refspec is reachable from a given head.

	Both the --ref and --head field can be any valid refspect.

	Under the hood this performs a 'git merge-base --is-ancestor <ref> <head>' query.
")

execute() {
	if [[ ${+head} -ne 1 ]]; then
		head=HEAD
	fi

	if git merge-base --is-ancestor "$ref" "$head"; then
		echo "true"
	else
		echo "false"
	fi
}


