desc="List commits in a Github pull request"
args=("--repo:The repository the PR was opened againt" \
	  "--pull:The PR number")
help=("pr-list-commits", "List commits in a Github pull request.

 Given a repository and a pull request number provide a list of commits which
 make up the pull request's contents in the local repository

 The pull argument omits the leading '#' of the pull request number.

 Commits are displayed in chronological order (oldest -> newest) in merge order.
 The merge order may be different then the commit timestamps.

 This search is not perfect since the commit IDs in the pull request may be
 different from the commit IDs in the local repository. This command uses
 'git log --grep' to search for an exact match of the commit's subject string.
 ")

execute() {
	IFS=$'\n'
	messages=($(gh pr view "${pull}" --repo ${repo} --json commits --jq '.commits[]| "\(.messageHeadline)"'))
	for x in "${messages[@]}"; do git log --format="%H | %s | %ai" --grep "$x"; done
}


