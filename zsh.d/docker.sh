# docker alias and functions
alias d='docker'
alias dps='docker ps --format "{{ .Names }}\t{{ .Ports }}\t{{ .Status }}"'
alias dlogs='docker logs -f'
alias dexec='docker exec -it'
alias di='docker images'
alias dpush='docker push'
dkill () {
	docker kill $1
	docker rm $1
}

