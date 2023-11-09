if [[ -e ~/Dropbox/Docs/OpenAIAPIToken ]]; then
    export OPENAI_API_KEY=$(cat ~/Dropbox/Docs/OpenAIAPIToken)
fi

function gpt() {
    theme=$(cat ~/.config/kitty/current-theme.conf | head -n 1 | tr -d ' ' | tr -d '#')
    if [[ $theme == 'light' ]]; then
        chatblade --theme 'paraiso-light' "$@"
    else
        chatblade "$@"
    fi
}

function gpt4() {
    theme=$(cat ~/.config/kitty/current-theme.conf | head -n 1 | tr -d ' ' | tr -d '#')
    if [[ $theme == 'light' ]]; then
        chatblade -c 'gpt-4-1106-preview' --theme 'paraiso-light' "$@"
    else
        chatblade -c 'gpt-4-1106-preview' "$@"
    fi
}
