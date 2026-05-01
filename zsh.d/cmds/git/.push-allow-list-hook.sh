#!/bin/bash
set -euo pipefail

remote="$1"

while read -r local_ref local_sha remote_ref remote_sha; do
  # skip deletions (local side is all zeros)
  [[ $local_sha =~ ^0+$ ]] && continue

  # enforce based on the destination branch on the remote, so colon-refspec
  # forms like `git push origin HEAD:refs/heads/main` can't bypass the check.
  [[ $remote_ref == refs/heads/* ]] || continue
  branch=${remote_ref#refs/heads/}

  mapfile -t allowed < <(git config --local --get-all allowlist."$branch".remote)

  # no allowlist for this branch → unrestricted
  [[ ${#allowed[@]} -eq 0 ]] && continue

  if ! printf '%s\n' "${allowed[@]}" | grep -Fxq "$remote"; then
	  echo "Branch '$branch' is not allowed to be pushed to remote '$remote'." >&2
	  echo "Allowed remotes: ${allowed[*]}" >&2
	  exit 1
  fi
done
