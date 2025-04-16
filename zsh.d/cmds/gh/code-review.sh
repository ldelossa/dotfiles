desc="Checkout a pull request to the local repository for review"
args=("--repo:The repository the PR was opened againt" \
	  "--number:The PR number")
help=("code-review", "Checkout a pull request to the local repository for review.

 The shell's current working directory must be the repository where the desired
 PR was opened again.

 When the pull request is checked out a special tag 'PR_BASE_COMMIT' is placed
 on the base commit of the pull request, if it can be determined.

 This script requires the 'gh' tool be available, configured, and authenticated
 with the github API along with the 'jq' tool.
 ")

execute() {
	gh --repo "${repo}" pr checkout "${number}" || return
	base_commit=$(gh pr list --repo "${repo}" --search "${number}" --json commits | jq -e -r .[0].commits[0].oid)
	if [ $? -eq 0 ]; then
		git tag --delete PR_BASE_COMMIT > /dev/null
		git tag "PR_BASE_COMMIT" "$base_commit"
		echo "Applied tag 'PR_BASE_COMMIT' to base commit $base_commit"
	fi
}


