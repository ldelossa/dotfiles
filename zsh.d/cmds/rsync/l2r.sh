desc="Sync the current local directory to the remote"
args=("--remote:The remote server to sync")
help=("l2r", "Sync the current local directory to the remote

 Be aware this is a sync and can be DESTRUCTIVE to newer files on the remote.

 Use caution and ensure no files on the remote need to be synced to the local
 working directory first.
")

execute() {
	rsync -e ssh --mkpath --delete -azv "$(pwd)"/ "$remote":"$(pwd)"
}

