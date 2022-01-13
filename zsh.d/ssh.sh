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
function ssh_mnt() {
    mkdir -p ~/vmmnt/$1
    sshfs root@$1:/root ~/vmmnt/$1 -o workaround=buflimit
}

function ssh_umnt() {
    umount ~/vmmnt/$1
    rm -rf ~/vmmnt/$1
}
