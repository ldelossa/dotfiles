desc="Connect claude code to an IDE in the current workspace folder"
args=()
help=("claude-ide", "Connect claude to an IDE in the current workspace folder.

 Claude can connect to a websocket server hosted by an IDE.
 The specific protocol is described well here:
 https://github.com/coder/claudecode.nvim/blob/main/PROTOCOL.md

 This command will follow the protocol and attempt to connect to an IDE if it
 determines one exists for the kernel workspace folder.
 ")

execute() {
	cwd="$(pwd)"
	for f in "$HOME"/.claude/ide/*; do
		ide_workspace=$(jq -r '.workspaceFolders[0]' "$f")
		if [[ $ide_workspace != "$cwd" ]]; then
			continue
		fi
		port=$(basename "$f" .lock)
		CLAUDE_CODE_SSE_PORT="$port" ENABLE_IDE_INTEGRATION="true" claude
		exit
	done
}

