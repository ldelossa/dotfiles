desc="Analyze pasted C structures with pahole"
args=()
help=("pahole.sh" "Analyze the layout of one or more C structures with pahole.

 Paste complete C structure declarations into standard input, then press Ctrl-D.
 The declarations are compiled with debug information and passed to pahole.

 The output shows member offsets and sizes, alignment holes, total size, and
 trailing padding. It does not report the structure's natural alignment as a
 standalone value.
")

execute() {
	local compiler="${CC:-cc}"

	if ! command -v "$compiler" >/dev/null 2>&1; then
		lib_error "ERROR: compiler '$compiler' was not found" >&2
		return 127
	fi

	if ! command -v pahole >/dev/null 2>&1; then
		lib_error "ERROR: pahole was not found" >&2
		return 127
	fi

	local work_dir
	if ! work_dir=$(mktemp -d); then
		lib_error "ERROR: could not create a temporary directory" >&2
		return 1
	fi
	trap "rm -rf -- ${(q)work_dir}" EXIT

	local source_file="$work_dir/structures.c"
	local object_file="$work_dir/structures.o"

	if [[ -t 0 ]]; then
		lib_info "Paste one or more complete C structure declarations, then press Ctrl-D:"
	fi

	if ! cat > "$source_file"; then
		lib_error "ERROR: could not read the C structure declarations" >&2
		return 1
	fi

	if [[ ! -s "$source_file" ]]; then
		lib_error "ERROR: no C structure declarations were provided" >&2
		return 1
	fi

	if ! "$compiler" \
		-g \
		-fno-eliminate-unused-debug-types \
		-c "$source_file" \
		-o "$object_file"; then
		lib_error "ERROR: could not compile the C structure declarations" >&2
		return 1
	fi

	if ! pahole --anon_include "$object_file"; then
		lib_error "ERROR: pahole could not analyze the compiled structures" >&2
		return 1
	fi
}
