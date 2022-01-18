# misc aliases 
alias digs="dig +short"
alias clearHosts='echo "" > ~/.ssh/known_hosts'
alias iso8601='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias ll='ls -la'
alias lsf='ls -laFGh'
alias m='make'
alias c='wl-copy'
alias xc='xclip -selection clipboard'
alias vim='nvim'

if which exa &> /dev/null; then
    alias ls='exa --header --git'
fi

if which ncdu &> /dev/null; then
    alias du='ncdu'
fi

if which duf &> /dev/null; then
    alias df='duf'
fi


