# zmodload zsh/zprof

# shell environment configurations
source ~/zsh.d/env.sh
# zsh specific configurations
source ~/zsh.d/zsh.sh
# misc alias
source ~/zsh.d/alias.sh
# docker aliases and configs
source ~/zsh.d/docker.sh
# fzf aliases and configs
source ~/zsh.d/fzf.sh
# gcloud aliases and configs
source ~/zsh.d/gcloud.sh
# git aliases and configs
source ~/zsh.d/git.sh
# go aliases and configs
source ~/zsh.d/go.sh
# kubectl aliases and configs
source ~/zsh.d/kubectl.sh
# oc aliases and configs
source ~/zsh.d/oc.sh
# ssh aliases and configs
source ~/zsh.d/ssh.sh
# tilix aliases and configs
source ~/zsh.d/tilix.sh
# sway aliases and configs
source ~/zsh.d/sway.sh
# systemd aliases and configs
source ~/zsh.d/systemd.sh
# aliases and helper functions for working
# with cilium
source ~/zsh.d/cilium.sh
source ~/zsh.d/bat.sh



# BEGIN_KITTY_SHELL_INTEGRATION
if test -e "$HOME/git/c/kitty/shell-integration/kitty.zsh"; then source "$HOME/git/c/kitty/shell-integration/kitty.zsh"; fi
# END_KITTY_SHELL_INTEGRATION
