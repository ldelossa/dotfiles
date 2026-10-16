desc="Analyze pasted C structures with pahole"
args=("--header:[o] Comma-separated headers to use instead of the defaults" \
	  "--bare:[o,b] Do not inject headers; overrides --header")
help=("pahole.sh" "Analyze the layout of one or more C structures with pahole.

 Paste complete C structure declarations into standard input, then press Ctrl-D.
 The declarations are compiled with debug information and passed to pahole.

 By default, stdint.h, stddef.h, and stdbool.h are injected so common C types
 are available. Use --header with a comma-separated list to replace those
 defaults. Use --bare to inject no headers; when both options are present,
 --bare wins and --header is ignored.

 The output shows member offsets and sizes, alignment holes, total size, and
 trailing padding. It does not report the structure's natural alignment as a
 standalone value.
")

execute() {
	setopt localoptions extendedglob

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
	local -a headers
	local -a include_args

	headers=()
	include_args=()
	if [[ ${+bare} -eq 0 ]]; then
		if [[ ${+header} -eq 1 ]]; then
			headers=("${(@s:,:)header}")
		else
			headers=(stdint.h stddef.h stdbool.h)
		fi

		local include_header
		for include_header in "${headers[@]}"; do
			include_header="${include_header##[[:space:]]#}"
			include_header="${include_header%%[[:space:]]#}"
			if [[ -z "$include_header" ]]; then
				lib_error "ERROR: --header contains an empty header name" >&2
				return 1
			fi
			include_args+=(-include "$include_header")
		done
	fi

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
		"${include_args[@]}" \
		-g \
		-fno-eliminate-unused-debug-types \
		-c "$source_file" \
		-o "$object_file"; then
		lib_error "ERROR: could not compile the C structure declarations" >&2
		return 1
	fi

	if ! pahole --anon_include --decl_exclude=/usr "$object_file"; then
		lib_error "ERROR: pahole could not analyze the compiled structures" >&2
		return 1
	fi
}
