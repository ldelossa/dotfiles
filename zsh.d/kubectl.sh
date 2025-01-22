# kubectl aliases
export kctx=''
function kctx() {
    if [[ -z  $1 ]]; then
        echo $kctx
        return
    fi
    kctx=$1
}

export kns="kube-system"
kconfig="$HOME/.kube/config"
function kns() {
    if [[ -z  $1 ]]; then
        echo $kns
        return
    fi
    kns=$1
}
alias kns-kube-system='kns kube-system'
alias kns-kube-default='kns default'

function kconfig() {
    if [[ -z  $1 ]]; then
        echo $kconfig
        return
    fi
    kconfig=$1
}

preamble='kubectl --kubeconfig $kconfig --namespace $kns --context=$kctx'

alias k=$preamble
alias ka="$preamble apply -f"
alias kr="$preamble delete -f"
alias kp="$preamble get pods"
alias kpw="$preamble get pods -o wide"
alias kp-net="$preamble get pods -o custom-columns=NAME:.metadata.name,IP:.status.podIP,NODE_IP:.status.hostIP,NODE:.spec.nodeName"
alias kd="$preamble get deployments"
alias kdel="$preamble delete"
alias ks="$preamble get services"
alias kn="$preamble get nodes"
alias kdesc="$preamble describe"
alias kexec="$preamble exec"
alias kiexec="$preamble exec -i -t"

function klogs() {
	eval "$preamble logs --timestamps $1 2>&1 | bat --theme=base16 -llog"
}

function klogsf() {
	eval "$preamble logs --timestamps --follow $1 2>&1 | bat --theme=base16 -llog"
}

function klogstream() {
    log_name=/tmp/klogstream_$1_$RANDOM.log
    eval "($preamble logs --timestamps --follow "$1" > $log_name)&"; bg_job=$!
    nvim -c "set syntax=log" $log_name # blocks until closed
    kill -SIGKILL $bg_job; rm -rf $log_name
}

# interactive exec into first pod which matches label
# $1 - label
# #2 - command
function kiexec-label() {
    kiexec $(k get pods -l="$1" -o json | jq -r ".items[0].metadata.name") $2
}

# exec command on first pod which matches label
# $1 - label
# #2 - command
function kexec-label() {
    kexec $(k get pods -l="$1" -o json | jq -r ".items[0].metadata.name") $2
}

function kshell() {
    shell=$2
    if [[ -z $shell ]]; then
        shell='/bin/bash'
    fi
    kiexec "$1" "$shell"
}
alias ksh=kshell

function kcluster-info() {
	k -o json get configmap kubeadm-config | jq -r .data.ClusterConfiguration
}

function kp-net6 {
	{
		echo -e "NAME\tIP\tNODE_IP\tNODE";
		eval "$preamble get pods -o json | jq -r '.items[] | [.metadata.name, .status.podIPs[1].ip, .status.hostIPs[1].ip, .spec.nodeName] | @tsv'"
	} | column -t
}

function k-netns() {
	pod=${1}
	echo -e "$(kexec "$pod" -- readlink /proc/1/ns/net 2>/dev/null)"
}

function kp-netns() {
	x=($(k get pods -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeName --no-headers))
	for (( i = 1; i <= ${#x}; i += 2)); do
		netns=$(k-netns "${x[$i]}")
		echo -e "${x[$i]} ${x[$i+1]} $netns"
	done | column -t -s ' '
}

# [NAME] [IMAGE] [NODE] [CMD (optional)]
function krun-node() {
	cmd=$(cat << EOF
$preamble run $1 -it --image $2 --overrides="{\"apiVersion\": \"v1\", \"spec\": { \"nodeName\": \"$3\" }}"
EOF
)
	if [[ -n ${4} ]]; then
		cmd="$cmd -- $4"
	fi
	eval $cmd
}
