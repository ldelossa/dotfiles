# zmodload zsh/zprof
export GOPATH=~/git/gopath
export GOBIN=~/git/gopath/bin
export GOSRC=~/git/gopath/src/
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/protoc-3.14.0/bin
export PATH=$PATH:/usr/lib/cargo/bin/
export PATH=$PATH:/Library/PostgreSQL/11/bin
export PATH=$PATH:/usr/local/flutter/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/goblog/bin
export KEYTIMEOUT=1
export CC=/usr/bin/clang
export CCX=/usr/bin/clang++
export EDITOR=vim
export NNN_PLUG='o:fzopen;c:chksum;d:diffs;h:hexview;s:suedit;l:-_git log'
export BAT_THEME='1337'
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export PATH="$PATH":"/usr/local/flutter/.pub-cache/bin"
export FZF_DEFAULT_OPTS='--color=bw'
export CHROME_EXECUTABLE=chromium-browser

# set pure prompt custom colors
zmodload zsh/nearcolor
zstyle :prompt:pure:path color 39
zstyle :prompt:pure:prompt:success color 208
zstyle :prompt:pure:git:branch color 208
zstyle :prompt:pure:git:arrow color 39
zstyle :prompt:pure:git:stash color 39
zstyle :prompt:pure:git:dirty color 39

# read from compinit cache unless date expired
autoload -Uz compinit

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


# misc aliases 
alias digs="dig +short"
alias clearHosts='echo "" > ~/.ssh/known_hosts'
alias iso8601='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias ll='ls -la'
alias lsf='ls -laFGh'
alias m='make'
alias c='xclip -selection clipboard'
alias v='xclip -o'
alias wayc='wl-copy'

# golang aliases
alias gt='go test -v -run '
alias gti='go test -v -tags integration -run '

# git aliases & functions
alias gsub='git submodule update --init --recursive'
gfpull() {
  branch=`git rev-parse --abbrev-ref HEAD`
  git fetch --all
  git checkout $branch
  git push fork origin/$branch:$branch
  git pull
}
ga() {
  git commit --amend --no-edit
  git push --force-with-lease
}
alias g='git'
alias gl='git log --format=short'
alias gpull='git pull'
alias ghw='gh repo view --web'

# gcloud aliases
alias gssh='gcloud compute ssh'
alias glist='gcloud compute instances list'
alias gscp-cd='gcloud compute scp --ssh-key-file=~/.ssh/louis_redhat_gcloud'

# docker alias and functions
alias dps='docker ps --format "{{ .Names }}\t{{ .Ports }}\t{{ .Status }}"'
alias dlogs='docker logs -f'
alias dexec='docker exec -it'
dkill () {
	docker kill $1
	docker rm $1
}


if [[ $XDG_SESSION_TYPE = 'wayland' ]] then;
    alias vim=vimx
fi

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


httpsGet() {
	curl "https://$1$2" -vvv
}

httpGet() {
	curl "http://$1$2" -vvv
}

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

# oc command doesnt get loaded in fpath for some reason...
if command oc > /dev/null; then
    source <(oc completion zsh)
fi

# zprof

