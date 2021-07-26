# oc command doesnt get loaded in fpath for some reason...
if command oc > /dev/null; then
    source <(oc completion zsh)
fi
