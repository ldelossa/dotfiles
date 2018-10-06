export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export GOPATH=~/git/go
export GOBIN=~/git/go/bin
export GOSRC=~/git/go/src/
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/bin/protobuf-3.5.1
export PATH=$PATH:/Users/louis/.scripts
export PATH=$PATH:/Library/PostgreSQL/10/bin
export KEYTIMEOUT=1

source "$HOME/.slimzsh/slim.zsh"
source ~/.zsh/completion/_kubectl
# source ~/.zsh/completion/_minikube
source ~/.zsh/completion/_google-cloud-sdk
source ~/.zsh/completion/_docker
source ~/.zsh/completion/_docker-compose
fpath=(~/.zsh/completion/ $fpath)
autoload -Uz compdef
compinit
source ~/google-cloud-sdk/path.zsh.inc

#ssh
ssh-add -l &>/dev/null
if [ "$?" == 2 ]; then
  test -r ~/.ssh-agent && \
    eval "$(<~/.ssh-agent)" >/dev/null

  ssh-add -l &>/dev/null
  if [ "$?" == 2 ]; then
    (umask 066; ssh-agent > ~/.ssh-agent)
    eval "$(<~/.ssh-agent)" >/dev/null
    ssh-add
  fi
fi

#disable auto correct
unsetopt correct_all

# shell-16 config
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# Set CDPATH
cdpath=(~/vmmnt/ ~/git ~/git/go/src ~/git/go/src/github.com ~/git/go/src/github.com/ldelossa ~/git/mirror ~/git/go/src/github.com/mirrorfitness)

alias digs="dig +short"
alias clearHosts='echo "" > ~/.ssh/known_hosts'
alias lsf='ls -laFGh'
alias gssh='gcloud compute ssh'
alias glist='gcloud compute instances list'
alias kubectl-dev='kubectl --namespace=dev'
alias kubectl-stag='kubectl --namespace=staging'
alias iso8601='date -u +"%Y-%m-%dT%H:%M:%SZ"'

bindkey -v
bindkey "^?" backward-delete-char
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^R' history-incremental-search-backward
bindkey '^F' forward-char
bindkey '^B' backward-char

VIM_PROMPT="❯"

dockerkill () {
	docker kill $1
	docker rm $1
}

httpsGet() {
	curl "https://$1$2" -vvv
}

httpGet() {
	curl "http://$1$2" -vvv
}


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/consul consul

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
