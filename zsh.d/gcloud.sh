# source and completes for google cloud
source ~/google-cloud-sdk/completion.zsh.inc
source ~/google-cloud-sdk/path.zsh.inc

# gcloud aliases
alias gssh='gcloud compute ssh'
alias glist='gcloud compute instances list'
alias gscp-cd='gcloud compute scp --ssh-key-file=~/.ssh/louis_redhat_gcloud'
