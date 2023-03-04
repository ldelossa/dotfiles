# zmodload zsh/zprof

# shell environment configurations
source ~/zsh.d/env.sh
# zsh specific configurations
source ~/zsh.d/zsh.sh
# misc alias
source ~/zsh.d/alias.sh
# docker aliases and configs
source ~/zsh.d/docker.sh
# fzf aliases and configs
source ~/zsh.d/fzf.sh
# gcloud aliases and configs
source ~/zsh.d/gcloud.sh
# git aliases and configs
source ~/zsh.d/git.sh
# go aliases and configs
source ~/zsh.d/go.sh
# kubectl aliases and configs
source ~/zsh.d/kubectl.sh
# ssh aliases and configs
source ~/zsh.d/ssh.sh
# tilix aliases and configs
source ~/zsh.d/tilix.sh
# sway aliases and configs
source ~/zsh.d/sway.sh
# systemd aliases and configs
source ~/zsh.d/systemd.sh
# aliases and helper functions for working
# with cilium
source ~/zsh.d/cilium.sh
source ~/zsh.d/bat.sh
source ~/zsh.d/devspaces.sh
source ~/zsh.d/gh.sh
source ~/zsh.d/kernel.sh
source ~/zsh.d/ip.sh

if [[ -f ~/zsh.d/chatgpt.sh ]]; then
    source ~/zsh.d/chatgpt.sh
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export KITTY_SHELL_INTEGRATION="enabled"
autoload -Uz -- /usr/lib64/kitty/shell-integration/zsh/kitty-integration; kitty-integration; unfunction kitty-integration

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/louis/google-cloud-sdk/path.zsh.inc' ]; then . '/home/louis/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/louis/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/louis/google-cloud-sdk/completion.zsh.inc'; fi
