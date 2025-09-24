if [[ -e ~/Dropbox/Docs/OpenAIAPIToken ]]; then
	OPENAI_API_KEY=$(cat ~/Dropbox/Docs/OpenAIAPIToken)
	export OPENAI_API_KEY
fi

if [[ -e ~/Dropbox/Docs/AnthropicAPIToken ]]; then
	ANTHROPIC_API_KEY=$(cat ~/Dropbox/Docs/AnthropicAPIToken)
	export ANTHROPIC_API_KEY
	export CLAUDE_API_KEY=$ANTHROPIC_API_KEY
fi

export LLM_MODEL=claude-4-sonnet
export LLM_SESSION=default

# all llm commands wrap aichat and make it useful in different ways.
function llm-set-session() {
	LLM_SESSION="$1"
}
function llm-get-session() {
	echo "$LLM_SESSION"
}

alias llm="aichat -s \$LLM_SESSION"
alias llm-sh="aichat -e"
alias llmdoc="cat <<'EOF' | llm "

function gpt() {
    theme=$(cat ~/.config/kitty/current-theme.conf | head -n 1 | tr -d ' ' | tr -d '#')
    if [[ $theme == 'light' ]]; then
        chatblade -c 'gpt-4o' --theme 'paraiso-light' "$@"
    else
        chatblade -c 'gpt-4o' "$@"
    fi
}

alias gptdoc="cat <<'EOF' | gpt "
