desc="Run a claude code instance using Isovalent claudegate proxy"
args=("--port:[o] Listening port of claudegate proxy")
args=("--model:[o] The model to use")
help=("claudegate" "Run a claude code instance using Isovalent claudegate proxy")

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

	# launch claudegate and get pid for later
	claudegate &> /tmp/claudegate.log &
	pid=$!

	# run claude, blocking until exit
	CLAUDE_CONFIG_DIR="$cfg"					\
	ANTHROPIC_BASE_URL="http://127.0.0.1:$port"	\
  	ANTHROPIC_AUTH_TOKEN="sk-ant-dummy"			\
  	ANTHROPIC_MODEL="claude-opus-4-7"			\
	claude

	# kill claudegate
	kill $pid
	rm -rf /tmp/claudegate.log
}
