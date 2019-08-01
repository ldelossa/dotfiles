# zmodload zsh/zprof
export GOPATH=~/git/gopath
export GOBIN=~/git/gopath/bin
export GOSRC=~/git/gopath/src/
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/bin/protobuf-3.5.1
export PATH=$PATH:/Users/louis/.scripts
# export PATH=$PATH:/Library/PostgreSQL/10/bin
export PATH=$PATH:/Library/PostgreSQL/11/bin
export GOOGLE_APPLICATION_CREDENTIALS=/Users/louis/.config/gcloud/ps-gcloud-service-account.json
export KEYTIMEOUT=1

# read from compinit cache unless date expired
autoload -Uz compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

# source slimzsh
source "$HOME/.slimzsh/slim.zsh"

# source and completes for google cloud
source ~/google-cloud-sdk/completion.zsh.inc
source ~/google-cloud-sdk/path.zsh.inc

# bash compleition support
autoload -U +X bashcompinit && bashcompinit

#ssh agent spawner
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

# theme used if base16 is commented out
# [ -n "$PS1" ] && sh /Users/louis/.local/share/nvim/plugged/snow/shell/snow_dark.sh

# # shell-16 config
# BASE16_SHELL=$HOME/.config/base16-shell/
# [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# # nvm configuration
# export NVM_DIR="$HOME/.nvm"
#   [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#   # [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# yvm import
# export YVM_DIR=/Users/louis/.yvm
# [ -r $YVM_DIR/yvm.sh ] && source $YVM_DIR/yvm.sh

# Set CDPATH
cdpath=(~/vmmnt/ ~/git ~/git/go ~/git/gopath/src ~/git/gopath/src/github.com ~/git/gopath/src/github.com/ldelossa)

alias digs="dig +short"
alias clearHosts='echo "" > ~/.ssh/known_hosts'
alias lsf='ls -laFGh'
alias gssh='gcloud compute ssh'
alias glist='gcloud compute instances list'
alias kubectl-dev='kubectl --namespace=dev'
alias kubectl-stag='kubectl --namespace=staging'
alias kubectl-prod='kubectl --namespace=prod'
alias iso8601='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias ll='ls -la'
alias git-sub='git submodule update --init --recursive'
alias git-yarn-foreach='git submodule foreach "yarn"'
alias ytdl='youtube-dl --extract-audio --audio-format mp3'
alias gssh-cd='gcloud compute ssh --ssh-key-file=~/.ssh/louis_redhat_gcloud'
alias gscp-cd='gcloud compute scp --ssh-key-file=~/.ssh/louis_redhat_gcloud'
alias vim='nvim'
alias kubectl-eq='kubectl --namespace=quay-enterprise'

# bindkey -v
bindkey "^?" backward-delete-char
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^F' forward-char
bindkey '^B' backward-char

# source fzf. must be after bindkeys 
source ~/.fzf.zsh


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


# zprof

