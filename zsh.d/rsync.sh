# rysnc current directy to remote via ssh
# l2r <user@host>
function l2r () {
    rsync -e ssh --mkpath --delete -azv "$(pwd)"/ "$1":"$(pwd)"
}

# rsync remote directory with local
# r2l <user@host>
function r2l () {
    rsync -e ssh --mkpath --delete -azv "$1":"$(pwd)" "$(pwd)"/ 
}
