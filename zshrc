#vx->vx_vnivx->vx_vno zmodload zsh/zprof

if [[ -f ~/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]
then
	ZVM_INIT_MODE=sourcing
 	source ~/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi

if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Shell-GPT integration ZSH v0.2
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd" --no-interaction)
	echo $BUFFER
    zle end-of-line
fi
}
zle -N _sgpt_zsh
bindkey ^h _sgpt_zsh
# Shell-GPT integration ZSH v0.2

# shell environment configurations
source ~/zsh.d/env.sh
source ~/zsh.d/zsh.sh
source ~/zsh.d/alias.sh
source ~/zsh.d/docker.sh
source ~/zsh.d/fzf.sh
source ~/zsh.d/gcloud.sh
source ~/zsh.d/git.sh
source ~/zsh.d/gh.sh # always include after git.sh
source ~/zsh.d/go.sh
source ~/zsh.d/kubectl.sh
source ~/zsh.d/ssh.sh
source ~/zsh.d/tilix.sh
source ~/zsh.d/sway.sh
source ~/zsh.d/systemd.sh
source ~/zsh.d/cilium.sh
source ~/zsh.d/bat.sh
source ~/zsh.d/devspaces.sh
source ~/zsh.d/kernel.sh
source ~/zsh.d/ip.sh
source ~/zsh.d/rsync.sh
source ~/zsh.d/mail.sh
source ~/zsh.d/gdb.sh
source ~/zsh.d/cgdb.sh
source ~/zsh.d/lldb.sh
source ~/zsh.d/netdata.sh
source ~/zsh.d/procs.sh
source ~/zsh.d/k9s.sh
source ~/zsh.d/ps.sh

if [[ -f ~/zsh.d/chatgpt.sh ]]; then
    source ~/zsh.d/chatgpt.sh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export KITTY_SHELL_INTEGRATION="enabled"
autoload -Uz -- /usr/lib64/kitty/shell-integration/zsh/kitty-integration; kitty-integration; unfunction kitty-integration

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/louis/google-cloud-sdk/path.zsh.inc' ]; then . '/home/louis/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/louis/googl-cloud-sdk/completion.zsh.inc' ]; then . '/home/louis/google-cloud-sdk/completion.zsh.inc'; fi

