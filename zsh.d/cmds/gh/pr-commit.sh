desc="Find the PR a commit was introduced in"
args=("--repo:The repository the PR was opened againt" \
	  "--commit:The commit to search for")
help=("pr-commit", "Find the PR a commit was introduced in

 Requires the repository the commit resides in along with the commit hash.
 The commit hash can be in both long and short canonical forms.

 This script requires the 'gh' tool be available, configured, and authenticated
 with the github API along with the 'jq' tool.
 ")

execute() {
	number=$(gh api repos/${repo}/commits/${commit}/pulls | jq .[].number)
	[[ -z $number ]] && lib_error "No PR exists for commit" && return
	gh --repo ${repo} pr view $number
}

