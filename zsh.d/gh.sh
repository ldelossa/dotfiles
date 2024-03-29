function gh-prfetch() {
   if [[ -z $1 ]]; then
       printf "error: must provide a pr number"
       return
   fi

   x=($(gh api "/repos/{owner}/{repo}/pulls/$1" | jq '{branch: .head.ref, remote: .head.repo.ssh_url, repo: .head.repo.full_name} | to_entries[] | [.value][0]'))

   branch=$(echo "${x[1]}" | tr -d '"')
   remote=$(echo "${x[2]}" | tr -d '"')
   repo=$(echo "${x[3]}" | tr -d '"')

   if [[ -z $branch ]]; then
       printf "error: failed to find branch name"
   fi
   if [[ -z $remote ]]; then
       printf "error: failed to find remote name"
   fi
   if [[ -z $repo ]]; then
       printf "error: failed to find repo name"
   fi

   printf "PR: $1\nRemote: %b\nRepo: %b\nBranch: %b\n\n" "$remote" "$repo" "$branch"

   # allow failure
   printf "Adding remote if necessary...\n"
   git remote add "$repo" "$remote" &> /dev/null

   printf "\nFetching branch...\n"
   git fetch "$repo" "$branch"

   printf "\nChecking branch out...\n"
   git checkout "$branch"
}

alias gh-iss-comment="gh issue comment -e"
alias gh-iss-edit="gh issue comment"
alias gh-iss-create="gh issue create"
alias gh-iss="gh issue view"

# If single argument is provided, its a shorthand for --label=$1
# If multiple, all arguments are forwarded as is
# If none, default list
function gh-iss-list() {
    if [ $# -eq 1 ]; then 
        gh issue list --label "$1"
        return
    fi
    if [ $# -gt 1 ]; then 
        gh issue list "$@"
        return
    fi
    gh issue list
}

alias gh-review='gh pr list -S "review-requested:@me"'
