#!/bin/bash

host=${1}
user=${2}

function log() {
	echo -e ""
	echo -e "\e[34m${1}\e[0m"
}

# bootstrap user sudo, must be able to login as root over ssh...
log "Configuring user ${user}..."
ssh root@"${host}" "useradd ${user} || true && cp -r ~/.ssh /home/${user}/ && chown -R ${user}:${user} /home/${user}"
ssh root@"${host}" "echo '${user} ALL=(ALL) ALL' >> /etc/sudoers"
ssh root@"${host}" "passwd ${user}"

scp ~/.config/cmds/scripts/automation/rocky-server-setup.sh "${user}"@"${host}":/tmp/rocky-server-setup.sh
ssh -t "${user}"@"${host}" "chmod +x /tmp/rocky-server-setup.sh && /tmp/rocky-server-setup.sh"
