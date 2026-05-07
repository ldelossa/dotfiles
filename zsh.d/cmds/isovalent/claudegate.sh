desc="Run a claude code instance using Isovalent claudegate proxy"
args=("--port:[o] Listening port of claudegate proxy")
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

	# launch claudegate and get pid for later
	claudegate &> /tmp/claudegate.log &
	pid=$!

	# run claude, blocking until exit
	ANTHROPIC_BASE_URL="http://127.0.0.1:$port" \
  	ANTHROPIC_AUTH_TOKEN="sk-ant-dummy"			\
  	ANTHROPIC_MODEL="claude-opus-4-7"			\
	claude

	# kill claudegate
	kill $pid
	rm -rf /tmp/claudegate.log
}
