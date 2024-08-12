
# watch the current directory and sync any changes to ${1} via rsync
# when changes occur
function watch-and-sync() {
	echo "Watching current directory and syncing to ${1}"
	inotifywait --exclude "FETCH_HEAD|index.lock|maintenance.lock" -m -r -e modify,create,delete,move . | while read -r x; do
			echo "------------------------$(date)------------------------"
			echo "$x"
        	/usr/local/bin/cmds rsync local-to-remote --remote "${1}"
	done
}

# watch the current directory and perform the command ${1} when changes occur
function watch() {
	echo "Watching current directory and execing ${1}"
	inotifywait --exclude "FETCH_HEAD|index.lock|maintenance.lock" -m -r -e modify,create,delete,move . | while read -r x; do
			echo "$x"
        	"${1}"
	done
}
