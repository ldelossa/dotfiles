# kubectl aliases
kns="default"
function kns() {
    if [[ -z  $1 ]]; then
        echo $kns
        return
    fi
    kns=$1
}
alias kns-kube-system='kns kube-system' 
alias kns-kube-default='kns kube-default' 

alias k='kubectl --namespace $kns'
alias kp='kubectl --namespace $kns get pods'
alias kp-net='kubectl --namespace $kns get pods -o custom-columns=NAME:.metadata.name,IP:.status.podIP,HOST_IP:.status.hostIP,NODE:.spec.nodeName'
alias kd='kubectl --namespace $kns get deployments'
alias kdel='kubectl --namespace $kns delete'
alias ks='kubectl --namespace $kns get services' 
alias kn='kubectl get nodes' 
alias kdesc='kubectl --namespace $kns describe'
alias kexec='kubectl --namespace $kns exec'
alias kiexec='kubectl --namespace $kns exec -i -t'
alias klogs='kubectl --namespace $kns logs'
