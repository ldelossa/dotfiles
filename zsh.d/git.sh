if [[ -e ~/Dropbox/Docs/GithubToken ]]; then
    export GITHUB_TOKEN=$(cat ~/Dropbox/Docs/GithubToken)
fi

# git aliases & functions
alias gsub='git submodule update --init --recursive'
alias gs='git status'
alias ga='git add'
alias gb='git branch --all -vv'
alias gaq='git commit --amend --no-edit'
alias gam='git commit --amend'
alias g='git'
alias gc="git commit"
alias gl='git log --format=short'
alias glo='git log --oneline '
alias gls='GIT_EXTERNAL_DIFF=difft git log -p --ext-diff'
alias gpull='git pull'
alias grc='git rebase --continue'
alias gf='git fetch'
alias gpf='git push --force-with-lease'
alias gchk='git checkout'
alias gsw='git switch'
alias gsh='git show'
alias gshs='GIT_EXTERNAL_DIFF=difft git show --ext-diff '
alias gshn='git show --name-only '
alias gr='git rebase'
alias gri='git rebase -i'
alias gst='git stash'
alias gstl='git stash list --pretty="%C(yellow)%gd %>(14)%Cgreen%cr %C(blue)%gs"'
alias gsp='git stash pop'
alias gsa='git stash apply'
alias gbr='git branch --format "%(refname:short) <> %(upstream)"'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdn='git diff --name-only'
alias gdt='git difftool'
alias gds='GIT_EXTERNAL_DIFF=difft git diff'
alias gdcs='GIT_EXTERNAL_DIFF=difft git diff --cached'
alias gintro='git log --diff-filter=A -- '
alias gcp='git cherry-pick'
alias gas='git rebase -i --autosquash '
alias gfix='git fix'
alias gl-sym='git log -S'
alias gw='git worktree'
alias gl-me='git log --author "Louis DeLosSantos"'

gsc() {
    git checkout stash@{$1} -- $2
}
glogs() {
    nvim <(curl -XGET "$1")
}

gshowat() {
    git show $1:$2
}

# gworktree {branch} {file}
# creates a temporary worktree checked out to {branch} and opens nvim to
# {file}.
# closing nvim will delete the worktree and return to the previous directly
#
# useful when you need to quickly look at a file's state in another branch or
# commit.
gworktree() {
	git worktree add ../worktree-${1} --checkout $1 && cd ../worktree-${1}
	nvim $2
	cd -
	git worktree remove ../worktree-${1}
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

# starting at commit, iterate until HEAD
# $1 - commit
function giter() {
	git rebase --exec='echo Stopping to review commit. Use ctrl-c to cancel iteration, ctrl-z to access terminal, fg + any-key to continue iteration && read' ${1}
}

function gl-range() {
	git log -L ${1},${2}:${3}
}

function gl-func() {
	git log -L:${1}:${2}
}

