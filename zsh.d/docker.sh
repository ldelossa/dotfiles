# docker alias and functions
alias d='docker'
alias dps='docker ps --format "{{ .Names }}\t{{ .Ports }}\t{{ .Status }}"'
alias dlogs='docker logs -f'
alias dexec='docker exec -it'
alias di='docker images'
alias drmi='docker rmi'
alias drm='docker rm'
alias dpush='docker push'
alias dit='docker images --format "{{.Repository}}:{{.Tag}}"'
dkill () {
	docker kill "$1"
	docker rm "$1"
}
dsh () {
	docker exec -it "${1}" /bin/sh
}
