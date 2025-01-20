# misc aliases 
alias digs="dig +short"
alias clearHosts='echo "" > ~/.ssh/known_hosts'
alias iso8601='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias ll='ls -la'
alias lsf='ls -laFGh'
alias m='make'
alias c='wl-copy'
alias xc='xclip -selection clipboard'
alias nvim='nvim --listen ~/.cache/nvim/nvim-$RANDOM.sock'
alias vim='nvim --listen ~/.cache/nvim/nvim-$RANDOM.sock'
alias nv='neovide --multigrid'
alias t='kitty --detach -d $(pwd)'

# heredoc with variable interp to stdout
alias doc='cat <<EOF'
# heredoc without variable interp to stdout
alias doc-literal="cat <<'EOF'"
# heredoc with variable interp to file
alias doc-file='cat <<EOF >'
# heredoc without variable interp to file
alias doc-file-literal="cat <<'EOF' >"
# heredoc with variable interp append to file
alias doc-append='cat <<EOF >>'
# heredoc without variable interp append to file
alias doc-append-literal="cat <<'EOF' >>"

if which exa &> /dev/null; then
    alias ls='exa --icons --header'
fi

if which eza &> /dev/null; then
    alias ls='eza --icons --header'
fi

if which ncdu &> /dev/null; then
    alias du='ncdu'
fi

if which duf &> /dev/null; then
    alias df='duf'
fi
