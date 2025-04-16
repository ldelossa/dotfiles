desc="Determine the commit a file was introduced in"
args=("--file:The file being searched")
help=("introduced", "Determine the commit a file was introduced in")

execute() {
	if [ -z "${file}" ]; then
	  exit 1
	fi

	git log --diff-filter=A -- "${file}"
}

