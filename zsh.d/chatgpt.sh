export LLM_MODEL=claude-4-sonnet

if [[ -e ~/Dropbox/Docs/OpenAIAPIToken ]]; then
    export OPENAI_API_KEY=$(cat ~/Dropbox/Docs/OpenAIAPIToken)
fi

if [[ -e ~/Dropbox/Docs/OpenAIAPIToken ]]; then
    export ANTHROPIC_API_KEY=$(cat ~/Dropbox/Docs/AnthropicAPIToken)
fi

function gpt4() {
    theme=$(cat ~/.config/kitty/current-theme.conf | head -n 1 | tr -d ' ' | tr -d '#')
    if [[ $theme == 'light' ]]; then
        chatblade -c 'gpt-4o' --theme 'paraiso-light' "$@"
    else
        chatblade -c 'gpt-4o' "$@"
    fi
}

function gpt() {
	gpt4 "$@"
}

alias gptdoc="cat <<'EOF' | gpt "
