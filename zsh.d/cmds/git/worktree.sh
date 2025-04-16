desc="Create a temprorary worktree."
args=("--ref: The git ref to check the workout out to" \
	  '--file: Open $EDITOR to a given file filel')
help=("worktree", "Create a temprorary worktree.

 Given your shell's current working directory is a repository, this script
 creates a worktree pointed to 'ref' and changes directory into it.

 A new shell is then opened in this directory, leaving the parent shell waiting
 for it's exit.

 If '--file' is specified the file will be opened directly.

 In both cases once the shell or editor exits the child shell will as well.
 The user of the script will then be placed in their original parent shell
 where they left off.

 This is useful for quickly glancing at file from another git ref.
 ")

execute() {
	git worktree add ../worktree-"${ref}" --checkout "${ref}" && cd ../worktree-"${ref}" || exit
	if [[ ${+file} -eq 1 ]]; then
		nvim "${file}"
	else
		zsh
	fi
	cd - || exit
	git worktree remove ../worktree-"${ref}"
}

