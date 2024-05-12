if [[ -e ~/Dropbox/Docs/OpenAIAPIToken ]]; then
    export OPENAI_API_KEY=$(cat ~/Dropbox/Docs/OpenAIAPIToken)
fi

function gpt4() {
    theme=$(cat ~/.config/kitty/current-theme.conf | head -n 1 | tr -d ' ' | tr -d '#')
    if [[ $theme == 'light' ]]; then
        chatblade -c 'gpt-4-turbo' --theme 'paraiso-light' "$@"
    else
        chatblade -c 'gpt-4-turbo' "$@"
    fi
}

function gpt() {
	gpt4 "$@"
}

alias gptdoc="cat <<'EOF' | gpt "
