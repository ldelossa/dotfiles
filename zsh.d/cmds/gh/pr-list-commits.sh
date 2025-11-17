desc="List commits in a Github pull request"
args=("--repo:The repository the PR was opened againt" \
	  "--pull:The PR number")
help=("pr-list-commits", "List commits in a Github pull request.

 Given a repository and a pull request number provide a list of commits which
 make up the pull request's contents.

 The pull argument omits the leading '#' of the pull request number.

 Commits are displayed in chronological order (oldest -> newest).
 ")

execute() {
	gh pr view "${pull}" --repo ${repo} --json commits --jq '.commits[]| "\(.oid[0:7]) \(.messageHeadline) \(.authoredDate)"'
}


