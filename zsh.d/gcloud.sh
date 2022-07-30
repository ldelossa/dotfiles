# source and completes for google cloud
[[ -d /usr/share/google-cloud-sdk/completion.zsh.inc  ]] && \
    source /usr/share/google-cloud-sdk/completion.zsh.inc

# gcloud aliases
alias gssh='gcloud compute ssh'
alias glist='gcloud compute instances list'
alias gscp-cd='gcloud compute scp --ssh-key-file=~/.ssh/louis_redhat_gcloud'
