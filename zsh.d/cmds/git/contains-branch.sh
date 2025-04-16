desc="Determine what branch a commit exists in"
args=("--commit:The commit hash")
help=("contains-branch", "Determine what branch a commit exists in")

execute() {
	git branch --contains "${commit}"
}
