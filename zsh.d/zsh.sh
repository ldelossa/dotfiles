# set pure prompt custom colors
zmodload zsh/nearcolor
zstyle :prompt:pure:path color 031
zstyle :prompt:pure:prompt:success color 028
zstyle :prompt:pure:prompt:failure color 131
zstyle :prompt:pure:git:branch color 028
zstyle :prompt:pure:git:arrow color 031
zstyle :prompt:pure:git:stash color 031
zstyle :prompt:pure:git:dirty color 031
zstyle :prompt:pure:git:stash color 031

PURE_PROMPT_SYMBOL="[%D{%I:%M:%S%p}] ▶"
PURE_PROMPT_VICMD_SYMBOL="[%D{%I:%M:%S%p}] "

if [ -n "$SHLVL" ]; then
	PURE_PROMPT_SYMBOL="[$SHLVL]${PURE_PROMPT_SYMBOL}"
	PURE_PROMPT_VICMD_SYMBOL="[$SHLVL]${PURE_PROMPT_VICMD_SYMBOL}"
fi

# if we are running in a DEVSPACE container, make our prompt indicate this.
if [ -n "$DEVSPACE" ]; then
    PURE_PROMPT_SYMBOL="($DEVSPACE)${PURE_PROMPT_SYMBOL}"
    PURE_PROMPT_VICMD_SYMBOL="($DEVSPACE)${PURE_PROMPT_VICMD_SYMBOL}"
fi

# if we are running in a distrobox container, make our prompt indicate this
if [ -n "$CONTAINER_ID" ]; then
    PURE_PROMPT_SYMBOL="($CONTAINER_ID)${PURE_PROMPT_SYMBOL}"
    PURE_PROMPT_VICMD_SYMBOL="($CONTAINER_ID)${PURE_PROMPT_VICMD_SYMBOL}"
fi

# read from compinit
autoload -Uz compinit

# source slimzsh
source "$HOME/.slimzsh/slim.zsh"

# bash completion support
autoload -U +X bashcompinit && bashcompinit

#disable auto correct
unsetopt correct_all

# use vim mode
bindkey -v

# emacs bindings
bindkey "^?" backward-delete-char
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^F' forward-char
bindkey '^B' backward-char

alias which-func='typeset -f'
