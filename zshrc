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
source ~/zsh.d/cilium.sh # always include after kubectl.sh
source ~/zsh.d/ssh.sh
source ~/zsh.d/tilix.sh
source ~/zsh.d/sway.sh
source ~/zsh.d/systemd.sh
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
source ~/zsh.d/inotify.sh
source ~/zsh.d/virsh.sh
source ~/zsh.d/gdbus.sh
source ~/zsh.d/devbox.sh
source ~/zsh.d/hosts.sh
source ~/zsh.d/cmds.sh

if [[ -f ~/zsh.d/chatgpt.sh ]]; then
    source ~/zsh.d/chatgpt.sh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -e /usr/lib64/kitty/shell-integration/zsh/kitty-integration ]]; then
	export KITTY_SHELL_INTEGRATION="enabled"
	autoload -Uz -- /usr/lib64/kitty/shell-integration/zsh/kitty-integration; kitty-integration; unfunction kitty-integration
fi

if [[ -e Applications/kitty.app/Contents/Resources/kitty/shell-integration/zsh/kitty-integration ]]; then
	export KITTY_SHELL_INTEGRATION="enabled"
	autoload -Uz -- Applications/kitty.app/Contents/Resources/kitty/shell-integration/zsh/kitty-integration kitty-integration; unfunction kitty-integration
fi

# If a share history file is available, use it.
if [[ -e $HOME/Dropbox/Fedora/.zsh_history ]]; then
	HISTFILE=~/Dropbox/Fedora/.zsh_history
fi

# if LIMA_VM is defined exec our shell directly into a linux VM on macOS
if [ -n "$LIMA_VM" ]; then
	exec ssh linux
fi
