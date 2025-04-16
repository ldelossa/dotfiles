# server side script which runs on the server being configured

function log() {
	echo -e ""
	echo -e "\e[34m${1}\e[0m"
}

log "Installing packages..."
sudo dnf -y copr enable varlad/zellij

sudo dnf -y copr enable agriffis/neovim-nightly

sudo dnf config-manager --add-repo=https://yum.fury.io/netdevops/ && \
	echo 'gpgcheck=0' | sudo tee -a /etc/yum.repos.d/yum.fury.io_netdevops_.repo

sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
					https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

sudo dnf install -y bat bear clang clang-tools-extra docker-compose exa fd-find \
					fuse-sshfs fzf htop btop jq neovim nmap moby-engine powertop \
					pv the_silver_searcher zsh gh rust nodejs-bash-language-server \
					nnn scdoc meson flex bison procs kubernetes-client helm npm  \
					gdb elfutils-libelf-devel openssl-devel dwarves zstd ripgrep \
					lld python3-docutils strace difftastic zsh-syntax-highlighting \
					bpftrace et btop pip strongswan NetworkManager-strongswan \
					NetworkManager-strongswan-gnome json-glib inotify-tools lldb \
					bpftool nasm glibc-static glibc-devel kitty-terminfo \
					kitty-shell-integration binutils-gold automake autoconf \
					libtool libbpf-devel

# qemu and kvm install
sudo dnf groupinstall -y virtualization

# install container-lab
sudo dnf config-manager --add-repo=https://yum.fury.io/netdevops/ && \
echo "gpgcheck=0" | sudo tee -a /etc/yum.repos.d/yum.fury.io_netdevops_.repo
sudo dnf install -y containerlab

# git repos
mkdir ~/git
mkdir ~/git/go
mkdir ~/git/c
mkdir ~/git/lua

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --update-rc

# slimzsh
git clone --recursive https://github.com/changs/slimzsh.git ~/.slimzsh

# docker zsh completion (doesn't ship with moby package)
curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker > /tmp/_docker
sudo mv /tmp/_docker /usr/share/zsh/site-functions
sudo chown root:root /usr/share/zsh/site-functions/_docker

# install golang
cd ~/git/go || exit
git clone https://github.com/udhos/update-golang.git
cd update-golang || exit
sudo ./update-golang.sh
cd /tmp || exit

# install gopls
/usr/local/go/bin/go install golang.org/x/tools/gopls@latest

# install dlv
/usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest

# install k9s
/usr/local/go/bin/go install github.com/derailed/k9s@latest

# install kind
/usr/local/go/bin/go install sigs.k8s.io/kind@latest

# docker buildx install
cd /tmp || exit
mkdir -p ~/.docker/cli-plugins
cd ~/.docker/cli-plugins || exit
curl -LO https://github.com/docker/buildx/releases/download/v0.20.1/buildx-v0.20.1.linux-amd64
mv buildx* docker-buildx
chmod u+x docker-buildx

## setup lua language server
cd ~/git/lua || exit
curl -LO https://github.com/LuaLS/lua-language-server/releases/download/3.13.5/lua-language-server-3.13.5-linux-x64.tar.gz
mkdir lua-language-server
tar -xvf lua-language-server-3.13.5-linux-x64.tar.gz -C lua-language-server
rm -rf lua-language-server-3.13.5-linux-x64.tar.gz
cd /tmp || exit

## setup vscode extracted lsps
sudo npm install -g vscode-langservers-extracted

## setup yaml language server
sudo npm install -g yaml-language-server

## setup bash language server
sudo npm install -g vim-language-server

# chatblade, shell-gpt, and b4 (python)
pip install chatblade b4 shell-gpt --upgrade

# add user to appropriate groups
log "Configuring user groups..."
sudo usermod -a "$(whoami)" -G docker
sudo usermod -a "$(whoami)" -G wheel
sudo usermod -a "$(whoami)" -G libvirt

# setup sysctls
log "Configuring sysctls..."
sudo echo 'fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-arptables = 0' | sudo tee /etc/sysctl.conf && sysctl -p

# services setup
log "Configuring services"
sudo systemctl disable firewalld
sudo systemctl stop firewalld

sudo systemctl enable libvirtd
sudo systemctl start libvirtd

sudo systemctl start docker
sudo systemctl enable docker

# deploy dotfiles
log "Deploying dotfiles..."
cd ~/git || exit
mkdir ~/.config
git clone https://github.com/ldelossa/dotfiles
cd dotfiles || exit
git remote remove origin
git remote add origin git@github.com:ldelossa/dotfiles
make all
# special step here to avoid kitty.conf being checked into git
echo 'include kitty_include.conf' > ~/.config/kitty/kitty.conf
cd /tmp || exit

# change shell
log "Changing shell to zsh..."
sudo chsh -s /bin/zsh "$(whoami)"

log "Deploying dotfiles for root..."
# configuring root user, leave dotfiles make till end, since it may return an
# exit code despite everything being okay.
sudo mkdir -p /root/git && sudo cp -R $HOME/git/dotfiles /root/git/dotfiles && \
sudo cp -R $HOME/.slimzsh /root/.slimzsh && \
sudo cp -R $HOME/.fzf/ /root/.fzf && sudo cp $HOME/.fzf.zsh /root/.fzf.zsh && \
sudo make -C /root/git/dotfiles all
