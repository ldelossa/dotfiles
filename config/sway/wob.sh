if pgrep wob; then
    return
fi
tail -f "$1" | wob
