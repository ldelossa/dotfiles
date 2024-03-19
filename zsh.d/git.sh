if [[ -e ~/Dropbox/Docs/GithubToken-Isovalent-TopHat ]]; then
    export GITHUB_TOKEN=$(cat ~/Dropbox/Docs/GithubToken)
fi

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
alias glo='git log --oneline '
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
alias gst='git stash'
alias gstl='git stash list --pretty="%C(yellow)%gd %>(14)%Cgreen%cr %C(blue)%gs"'
alias gsp='git stash pop'
alias gsa='git stash apply'
alias gbr='git branch --format "%(refname:short) <> %(upstream)"'
alias gd='git diff'
alias gdn='git diff --name-only'
alias gdt='git difftool'
alias gintro='git log --diff-filter=A -- '
alias gcp='git cherry-pick'
alias gas='git rebase -i --autosquash '
alias gfix='git fix'

gsc() {
    git checkout stash@{$1} -- $2
}
glogs() {
    nvim <(curl -XGET "$1")
}

gshowat() {
    git show $1:$2
}

# gedit {branch} {file}
# creates a temporary worktree checked out to {branch} and opens nvim to 
# {file}.
#
# useful when you need to quickly look at a file's state in another branch or
# commit.
gedit() {
	git worktree add ../tmp --checkout $1 && cd ../tmp
	nvim $2
	cd -
	git worktree remove ../tmp
}

# intersecting diff, performs a diff between head:file and $1:file for all
# changed files in $1, where $1 is a git-rev.
ginterdiff() {
	from=$1
	to=$2

	if [[ -z $from ]]; then
		echo "FROM commit not provided"
		return
	fi

	if [[ -z $to ]]; then
		echo "TO commit not provided"
		return
	fi

    echo "Will show diffs for the following files"
    echo ""
    git show --pretty=format: --name-only "$1"
    echo ""
    echo "Hit any key to continue, <ctrl-c> to cancel."
    read
    git show --pretty=format: --name-only "$1" | xargs -I{} git diff "$1":{} "$2":{}
}

alias giter="GIT_SEQUENCE_EDITOR=\"sed -i -e 's/^pick/edit/'\" git rebase --interactive"

