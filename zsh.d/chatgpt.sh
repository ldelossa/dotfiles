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
        chatblade -c 4 --theme 'paraiso-light' "$@"
    else
        chatblade -c 4 "$@"
    fi
}
