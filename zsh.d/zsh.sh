# set pure prompt custom colors
zmodload zsh/nearcolor
zstyle :prompt:pure:path color 39
zstyle :prompt:pure:prompt:success color 208
zstyle :prompt:pure:git:branch color 208
zstyle :prompt:pure:git:arrow color 39
zstyle :prompt:pure:git:stash color 39
zstyle :prompt:pure:git:dirty color 39

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
