desc="Git diff using the difft command"
args=("--extra:Extra arguments to git show")
help=("contains-branch", "Git diff using the difft command

 Produces a diff using the difft command.
 The difft command must be present on the machine.
 ")

execute() {
	GIT_EXTERNAL_DIFF=difft git show --ext-diff "${extra}"
}

