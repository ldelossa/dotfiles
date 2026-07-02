desc="Run a claude code instance using Isovalent claudegate proxy"
args=("--port:[o] Listening port of claudegate proxy" \
	  "--model:[o] The model to use")
help=("claudegate" "Run a claude code instance using Isovalent claudegate proxy

This commands supports argument forwarding where any arguments provided after
a '--' will be fed directly to the 'claude' command. Most useful when using
the '--resume' functionality.
")

execute() {
	# if GITHUB_TOKEN is set, unset it, claudegate needs to authenticate
	# on its own.
	if [ -n "$GITHUB_TOKEN" ]; then
		unset GITHUB_TOKEN
	fi

	if [ ${+port} == 0 ]; then
		port=8080
	fi

	# use a separate config dir so the banner does not show the personal
	# API account. symlink the global config bits so CLAUDE.md, settings,
	# and plugins still apply, but omit .credentials.json so claude falls
	# back to ANTHROPIC_AUTH_TOKEN.
	local cfg="$HOME/.claude-claudegate"
	mkdir -p "$cfg"
	ln -sfn "$HOME/.claude/CLAUDE.md"           "$cfg/CLAUDE.md"
	ln -sfn "$HOME/.claude/settings.json"       "$cfg/settings.json"
	ln -sfn "$HOME/.claude/settings.local.json" "$cfg/settings.local.json"
	ln -sfn "$HOME/.claude/plugins"             "$cfg/plugins"
	ln -sfn "$HOME/.claude/projects"            "$cfg/projects"

	local log_file="/tmp/claudegate-${port}.log"
	local pid=""

	cleanup() {
		if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
			kill "$pid" 2>/dev/null || true
			wait "$pid" 2>/dev/null || true
		fi
		rm -f "$log_file"
	}
	trap cleanup EXIT

	# launch claudegate on the selected port and get pid for later
	lib_info "Starting claudegate on http://127.0.0.1:$port (log: $log_file)"
	CLAUDEGATE_PORT="$port" claudegate &> "$log_file" &
	pid=$!

	# run claude, blocking until exit
	CLAUDE_CONFIG_DIR="$cfg"					\
	ANTHROPIC_BASE_URL="http://127.0.0.1:$port"	\
  	ANTHROPIC_AUTH_TOKEN="sk-ant-dummy"			\
  	ANTHROPIC_MODEL="claude-opus-4-7"			\
	claude "${forwarded[@]}"
}
