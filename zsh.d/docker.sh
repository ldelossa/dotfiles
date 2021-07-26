# docker alias and functions
alias dps='docker ps --format "{{ .Names }}\t{{ .Ports }}\t{{ .Status }}"'
alias dlogs='docker logs -f'
alias dexec='docker exec -it'
dkill () {
	docker kill $1
	docker rm $1
}

