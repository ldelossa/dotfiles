# git aliases & functions
alias gsub='git submodule update --init --recursive'
gfpull() {
  branch=`git rev-parse --abbrev-ref HEAD`
  git fetch --all
  git checkout $branch
  git push fork origin/$branch:$branch
  git pull
}
gap() {
  git commit --amend --no-edit
  git push --force-with-lease
}
alias gs='git status'
alias ga='git add'
alias gb='git branch --all -vv'
alias gaq='git commit --amend --no-edit'
alias gam='git commit --amend'
alias g='git'
alias gc="git commit"
alias gl='git log --format=short'
alias gpull='git pull'
alias ghw='gh repo view --web'
alias grc='git rebase --continue'
alias gf='git fetch'
alias gpf='git push --force-with-lease'
alias gchk='git checkout'
alias gsw='git switch'
alias gsh='git show'
alias gr='git rebase'
alias gri='git rebase -i'
alias gst='git stash '
alias gsp='git stash pop'
alias gsa='git stash apply'
alias gbr='git branch --format "%(refname:short) <> %(upstream)"'
alias gd='git diff'
alias gdn='git diff --name-only'

gsc() {
    git checkout stash@{$1} -- $2
}
glogs() {
    nvim <(curl -XGET "$1")
}
