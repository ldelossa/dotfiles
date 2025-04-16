desc="Show diff for only changed files between A and B"
args=("--a=The ref presenting a set of changed files" \
	  "--b=The ref to diff files from 'a' against")
help=("interdiff" "Show diff for only changed files between A and B

 Intersecting diff.
 This script will determine the changed file in ref 'a'.
 It will then diff ONLY these files against ref 'b'.

 This is useful when you have two branches which may differ significantly, but
 you only want to see the diff between files edited in a particular commit (a).

 Each diff is presented separately.
 You may hit <ctrl-c> to cancel the iteration.
 Any key will continue the iteration.
")


execute() {
	lib_info "Will show diffs for the following files"
	echo ""
	git show --pretty=format: --name-only "$a"
	echo ""
	lib_info "Hit any key to continue, <ctrl-c> to cancel."
	read -r
	git show --pretty=format: --name-only "$a" | xargs -I{} git diff "$a":{} "$b":{}
}

