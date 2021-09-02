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
alias ga='git commit --amend'
alias gaq='git commit --amend --no-edit'
alias gadd='git add'
alias g='git'
alias gc="git commit"
alias gl='git log --format=short'
alias gpull='git pull'
alias ghw='gh repo view --web'
alias grc='git rebase --continue'
alias gf='git fetch'
alias gpf='git push --force-with-lease'
alias gchk='git checkout'
alias gri='git rebase -i'

glogs() {
    nvim <(curl -XGET "$1")
}
