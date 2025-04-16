desc="Sync the current local directory from the remote"
args=("--remote:The remote server to sync from")
help=("l2r", "Sync the current local directory from the remote

 Be aware this is a sync and can be DESTRUCTIVE to newer files in the local 
 directory.

 Use caution and ensure no files in the local directory need to be synced to
 the remote first.
")

execute() {
	rsync -e ssh --mkpath --delete -azv "$remote":"$(pwd)" "$(pwd)"/
}

