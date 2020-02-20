# zmodload zsh/zprof
export GOPATH=~/git/gopath
export GOBIN=~/git/gopath/bin
export GOSRC=~/git/gopath/src/
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/bin/protobuf-3.5.1
export PATH=$PATH:/usr/lib/cargo/bin/
export PATH=$PATH:/Library/PostgreSQL/11/bin
export GOOGLE_APPLICATION_CREDENTIALS=/Users/louis/.config/gcloud/ps-gcloud-service-account.json
export KEYTIMEOUT=1
export CC=/usr/bin/clang
export CCX=/usr/bin/clang++

# set pure prompt custom colors
zmodload zsh/nearcolor
zstyle :prompt:pure:path color 39
zstyle :prompt:pure:prompt:success color 208
zstyle :prompt:pure:git:branch color 208
zstyle :prompt:pure:git:arrow color 39
zstyle :prompt:pure:git:stash color 39
zstyle :prompt:pure:git:dirty color 39

# read from compinit cache unless date expired
# autoload -Uz compinit
# if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
#   compinit
# else
#   compinit -C
# fi

# source slimzsh
source "$HOME/.slimzsh/slim.zsh"

# source and completes for google cloud
source ~/google-cloud-sdk/completion.zsh.inc
source ~/google-cloud-sdk/path.zsh.inc

# bash completion support
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
    ssh-add ~/.ssh/* &>/dev/null
  fi
fi

#disable auto correct
unsetopt correct_all

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
alias kubectl-eq='kubectl --namespace=quay-enterprise'
alias m='make'
alias ls='ls --color=auto'
alias c='xclip -selection clipboard'
alias v='xclip -o'

bindkey -v
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

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

# zprof

