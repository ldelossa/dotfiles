# kubectl aliases
kns="kube-system"
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

preamble='kubectl --kubeconfig $kconfig --namespace $kns'

alias k=$preamble
alias kp="$preamble get pods"
alias kp-net="$preamble get pods -o custom-columns=NAME:.metadata.name,IP:.status.podIP,HOST_IP:.status.hostIP,NODE:.spec.nodeName"
alias kd="$preamble get deployments"
alias kdel="$preamble delete"
alias ks="$preamble get services" 
alias kn="$preamble get nodes" 
alias kdesc="$preamble describe"
alias kexec="$preamble exec"
alias kiexec="$preamble exec -i -t"
alias klogs="$preamble logs --timestamps "
alias klogsf="$preamble logs --timestamps --follow "

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
