desc="Show a file at a particular reference"
args=("--ref:The git ref of the file" \
	  "--file:The file to view at ref")
help=("show-at" "Show a file at a particular reference")

execute() {
 git show "${ref}":"${file}"
}

