#!/bin/bash

# rpm fusion free
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
	 https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

# install multimedia codecs
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf group upgrade -y --with-optional Multimedia

# add swayfx copr
sudo dnf copr enable -y swayfx/swayfx
sudo dnf copr enable -y agriffis/neovim-nightly
sudo dnf copr enable -y ldelossa/Way-Shell

# desktop relatived packages
sudo dnf install -y alacritty asciinema brightnessctl grim pavucontrol \
					slurp swappy swayfx xdg-desktop-portal-wlr libnotify-devel \
					pam-devel gtk3-devel gtk-layer-shell-devel wf-recorder  \
					libxkbcommon-x11-devel xcb-util-devel xcb-util-wm-devel \
					xcb-util-cursor-devel wayland-protocols-devel \
					bluez startup-notification-devel libnl3-devel \
					libmpdclient-devel grimshot blueman llvm-devel \
					intel-media-driver wireshark way-shell upower-devel \
					wireplumber-devel pulseaudio-libs-devel \
					NetworkManager-libnm-devel kitty libadwaita-devel \
					gtk4-layer-shell-devel json-glib-devel shasum neomutt \
					lei perl-open

# flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists fedora oci+https://registry.fedoraproject.org

# flatpak installs
flatpak install com.dropbox.Client
flatpak install md.obsidian.Obsidian
flatpak install org.signal.Signal
flatpak install org.zealdocs.Zeal

# chatblade, shell-gpt, and b4 (python)
pip install chatblade b4 shell-gpt --upgrade

## setup gtklock
cd ~/git/c || exit
git clone https://github.com/jovanlanik/gtklock.git
cd gtklock || exit
git checkout v2.1.0
make
sudo make install-bin
sudo cp ~/.config/gtklock/gtklock.pam /etc/pam.d/gtklock
cd /tmp || exit

## The follow sections assume Dropbox is setup on the workstation
echo "Please finish setting up Dropbox, then press any key to continue..."
read -r

# ssh keys
mkdir ~/.ssh
cp ~/Dropbox/Docs/ldelossa_github_id_rsa* ~/.ssh
chmod 600 ~/.ssh/*
eval "$(ssh-agent)"
ssh-add ~/.ssh/*

# 1password rpm install
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf install 1password

## install font
sudo mkdir /usr/share/fonts/
sudo cp ~/Dropbox/Fonts/* /usr/share/fonts/
sudo fc-cache -v

## install network manager connections
sudo cp ~/Dropbox/Fedora/network_manager/* /etc/NetworkManager/system-connections
sudo chown root:root /etc/NetworkManager/system-connections/*
sudo chmod 600 /etc/NetworkManager/system-connections/*
