#ssh agent spawner
ssh-add -l &>/dev/null
if [ "$?" == 2 ]; then
  test -r ~/.ssh-agent && \
    eval "$(<~/.ssh-agent)" >/dev/null

  ssh-add -l &>/dev/null
  if [ "$?" == 2 ]; then
    (umask 066; ssh-agent > ~/.ssh-agent)
    eval "$(<~/.ssh-agent)" >/dev/null
    ssh-add ~/.ssh/* &>/dev/null
  fi
fi

alias ssh="TERM=xterm-256color ssh"

#ssh mount helper
function vmount() {
    root="/root"
    if [[ -n $2 ]] then
        root=$2
    fi
    mkdir -p ~/vmmnt/$1
    sshfs root@$1:$root ~/vmmnt/$1 -o idmap=user -o workaround=buflimit -o Ciphers=chacha20-poly1305@openssh.com -o Compression=no -o allow_other -o kernel_cache
}

function vumount() {
    umount ~/vmmnt/$1 && rm -rf ~/vmmnt/$1
}
