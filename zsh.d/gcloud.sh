# source and completes for google cloud
[[ -e /usr/share/google-cloud-sdk/completion.zsh.inc  ]] && \
    source /usr/share/google-cloud-sdk/completion.zsh.inc

# gcloud aliases
alias gcssh='gcloud compute ssh'
alias gclist='gcloud compute instances list'
alias gcdelete='gcloud compute instances delete'
