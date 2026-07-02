desc="Run checkpatch against working-tree changes"
args=("--target:[o] Path to check, defaults to the current directory" \
	  "--container_engine:[o] Container engine to use, defaults to CONTAINER_ENGINE or docker" \
	  "--image:[o] Checkpatch container image to use" \
	  "--debug:[o,b] Run the container shell with tracing enabled" \
	  "--show_patch:[o,b] Print the generated patch before running checkpatch")
help=("checkpatch", "Run checkpatch against working-tree changes

 This is an escape hatch for cases where a repository's checkpatch wrapper
 expects an ideal git history/range and fails before checking the actual
 working tree.

 Run this from the directory you want to check. The command creates a temporary
 git index, includes tracked modifications, deletions, staged changes, and
 untracked files under the selected path, then pipes that patch into the Cilium
 checkpatch container.

 Extra checkpatch.pl arguments can be passed after '--'. Example:

   cmds kernel checkpatch.sh -- --strict
")

execute() {
	set -e

	local default_image="quay.io/cilium/cilium-checkpatch:1755701578-b97bd7a@sha256:f1332fa6edbbd40882a59ceae4a7843a4095bd62288363740e84b82708624c50"
	local target_path="${target:-.}"
	local engine="${container_engine:-${CONTAINER_ENGINE:-docker}}"
	local checkpatch_image="${image:-${CHECKPATCH_IMAGE:-$default_image}}"

	if ! command -v "$engine" >/dev/null 2>&1; then
		lib_error "ERROR: container engine '$engine' was not found"
		return 1
	fi

	local target_abs
	target_abs=$(realpath "$target_path")

	local git_context="$target_abs"
	if [[ -f "$target_abs" ]]; then
		git_context=$(dirname "$target_abs")
	fi

	local repo_root
	if ! repo_root=$(git -C "$git_context" rev-parse --show-toplevel 2>/dev/null); then
		lib_error "ERROR: '$target_path' is not inside a git repository"
		return 1
	fi

	local target_rel
	target_rel=$(realpath --relative-to="$repo_root" "$target_abs")
	if [[ -z "$target_rel" ]]; then
		target_rel="."
	fi

	local real_index
	real_index=$(git -C "$repo_root" rev-parse --path-format=absolute --git-path index)

	local tmp_index
	tmp_index=$(mktemp)
	local patch_file
	patch_file=$(mktemp)
	trap 'rm -f "$tmp_index" "$patch_file"' EXIT

	if [[ -f "$real_index" ]]; then
		cp "$real_index" "$tmp_index"
	fi

	# Use a temporary index so untracked files can be included with intent-to-add
	# without mutating the user's real git index.
	GIT_INDEX_FILE="$tmp_index" git -C "$repo_root" add -N -- "$target_rel"
	GIT_INDEX_FILE="$tmp_index" git -C "$repo_root" diff \
		--no-ext-diff \
		--binary \
		--find-renames \
		HEAD \
		-- "$target_rel" > "$patch_file"

	if [[ ! -s "$patch_file" ]]; then
		lib_info "No working-tree changes found under '$target_rel'."
		return 0
	fi

	if [[ ${+show_patch} -eq 1 ]]; then
		cat "$patch_file"
	fi

	local -a checkpatch_args
	checkpatch_args=(--ignore MACRO_ARG_REUSE --ignore CONST_STRUCT)
	if [[ ${#forwarded[@]} -gt 0 ]]; then
		checkpatch_args+=("${forwarded[@]}")
	fi

	local container_script='
set -e
checkpatch=""
for candidate in \
  /checkpatch/checkpatch.pl \
  /checkpatch/linux/scripts/checkpatch.pl \
  /linux/scripts/checkpatch.pl \
  /usr/src/linux/scripts/checkpatch.pl \
  /scripts/checkpatch.pl; do
  if [[ -x "$candidate" ]]; then
    checkpatch="$candidate"
    break
  fi
done

if [[ -z "$checkpatch" ]]; then
  echo "ERROR: could not find checkpatch.pl in the checkpatch image" >&2
  exit 127
fi

exec "$checkpatch" --no-tree "$@" -
'

	local -a bash_flags
	bash_flags=()
	if [[ ${+debug} -eq 1 || -n "${CHECKPATCH_DEBUG:-}" ]]; then
		bash_flags=(-x)
	fi

	lib_info "Running checkpatch for working-tree changes under '$target_rel'."
	"$engine" container run --rm -i \
		--workdir /workspace \
		--volume "$repo_root:/workspace" \
		--user "$(id -u):$(id -g)" \
		--entrypoint /bin/bash \
		"$checkpatch_image" \
		"${bash_flags[@]}" \
		-c "$container_script" \
		checkpatch \
		"${checkpatch_args[@]}" < "$patch_file"
}
