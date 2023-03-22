if [[ -e ~/Dropbox/Docs/OpenAIAPIToken ]]; then
    export OPENAI_API_KEY=$(cat ~/Dropbox/Docs/OpenAIAPIToken)
fi
alias gpt=chatblade
alias gpt-code="sgpt --code"
