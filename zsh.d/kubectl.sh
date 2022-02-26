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
