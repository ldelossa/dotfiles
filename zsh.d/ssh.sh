#ssh agent spawner
ssh-add -l &>/dev/null
if [ "$?" != 0 ]; then
  test -r ~/.ssh-agent && \
    eval "$(<~/.ssh-agent)" >/dev/null

  ssh-add -l &>/dev/null
  if [ "$?" != 0 ]; then
    (umask 066; ssh-agent > ~/.ssh-agent)
    eval "$(<~/.ssh-agent)" >/dev/null
    ssh-add ~/.ssh/* &>/dev/null
  fi
fi

alias ssh="TERM=xterm-256color ssh"
alias s=ssh

function sshu() {
    ssh louis@"${1}"
}
function sshr() {
    ssh root@"${1}"
}
