#vx->vx_vnivx->vx_vno zmodload zsh/zprof

if [[ -f ~/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]
then
	ZVM_INIT_MODE=sourcing
 	source ~/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi

if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

_pi_shell_zsh() {
    [[ -n "$BUFFER" ]] || return 0

    local _old=$BUFFER _cursor=$CURSOR _command _os
    case "$(uname -s)" in
        Darwin) _os="macOS $(sw_vers -productVersion)" ;;
        *) _os="$(uname -s)" ;;
    esac
    local _prompt="Provide only zsh commands for $_os without any description.
Ensure the output is a valid zsh command.
If there is a lack of details, provide most logical solution.
If multiple steps are required, try to combine them using '&&'.
Output only plain text without any markdown formatting."

    BUFFER+="⌛"
    zle -I && zle redisplay
    if _command=$(print -r -- "$_old" | command pi \
        --print --mode text --offline \
        --provider openai-codex --model gpt-6-luna --thinking low \
        --no-session --no-tools --no-extensions --no-mcp \
        --no-skills --no-prompt-templates --no-context-files --no-approve \
        --system-prompt "$_prompt" --append-system-prompt ''); then
        if [[ -n ${_command//[[:space:]]/} ]]; then
            BUFFER=$_command
            zle end-of-line
        else
            BUFFER=$_old
            CURSOR=$_cursor
            zle -M 'Pi returned no command; original input restored.'
        fi
    else
        BUFFER=$_old
        CURSOR=$_cursor
        zle -M 'Pi failed; original input restored.'
    fi
    zle redisplay
}

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
# source the cmds/ framework
source ~/zsh.d/cmds/.lib.sh
source ~/zsh.d/llm.sh
source ~/zsh.d/aws.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -e /usr/lib64/kitty/shell-integration/zsh/kitty-integration ]]; then
	export KITTY_SHELL_INTEGRATION="enabled"
	autoload -Uz -- /usr/lib64/kitty/shell-integration/zsh/kitty-integration; kitty-integration; unfunction kitty-integration
fi

if [[ -e /Applications/kitty.app/Contents/Resources/kitty/shell-integration/zsh/kitty-integration ]]; then
	export KITTY_SHELL_INTEGRATION="enabled"
	autoload -Uz -- /Applications/kitty.app/Contents/Resources/kitty/shell-integration/zsh/kitty-integration kitty-integration; unfunction kitty-integration
fi

if [[ "$TERM_PROGRAM" == "WezTerm" && -r /Applications/WezTerm.app/Contents/Resources/wezterm.sh ]]; then
 source /Applications/WezTerm.app/Contents/Resources/wezterm.sh
fi

# If a share history file is available, use it.
if [[ -e $HOME/Dropbox/Fedora/.zsh_history ]]; then
	HISTFILE=~/Dropbox/Fedora/.zsh_history
fi

# Bind after initialization so Ctrl+H does not depend on the initial keymap.
zle -N _pi_shell_zsh
bindkey -M viins '^H' _pi_shell_zsh
bindkey -M emacs '^H' _pi_shell_zsh

# if LIMA_VM is defined exec our shell directly into a linux VM on macOS
if [ -n "$LIMA_VM" ]; then
	exec ssh linux
fi
