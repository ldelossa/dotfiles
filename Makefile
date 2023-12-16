configs := $(notdir $(wildcard ./config/*))
user_configs := $(addprefix $(HOME)/.config/, $(configs))

default:
	@echo Usage:
	@echo make link-configs 			- link ./config dirs to home directory
	@echo make link-zsh					- link zshrc and zsh.d directories
	@echo make link-gdb-config			- link .gdbinit to ~/.gdbinit
	@echo make link-global-gitignore	- link and configure git with global .gitignore file
	@echo make link-clang-format	    - link global clang-format
	@echo make linkg-git-config 	    - link global git config
	@echo resulting config directories: \
		$(user_configs)

all: link-configs link-zsh link-gdb-config link-global-gitignore link-clang-format link-mail link-docker-config

link-configs: $(user_configs)

$(user_configs):
	-mkdir $(HOME)/.config
	-unlink $@
	ln -s $(subst $(HOME)/.config,$(shell pwd)/config,$@) $@

link-zsh:
	-unlink ~/.zshrc
	-unlink ~/zsh.d
	ln -s $(HOME)/git/dotfiles/zshrc $(HOME)/.zshrc
	ln -s $(HOME)/git/dotfiles/zsh.d $(HOME)/zsh.d

link-gdb-config:
	-unlink $(HOME)/.gdbinit
	ln -s $(HOME)/git/dotfiles/config/gdb/.gdbinit $(HOME)/.gdbinit

link-global-gitignore:
	-unlink ~/.gitignore
	ln -s $(HOME)/git/dotfiles/global_git_ignore $(HOME)/.gitignore
	git config --global core.excludesfile '~/.gitignore'

link-docker-config:
	-unlink ~/.docker/config.json
	ln -s $(HOME)/git/dotfiles/config/.docker/config.json $(HOME)/.docker/config.json

link-clang-format:
	-unlink ~/.clang-format
	ln -s $(HOME)/git/dotfiles/config/clang-format/clang-format $(HOME)/.clang-format

link-mail:
	-unlink ~/.config/mutt
	ln -s ~/Dropbox/Fedora/system_setup/mutt ~/.config/mutt
	-unlink ~/.msmtprc
	ln -s ~/Dropbox/Fedora/system_setup/.msmtprc ~/.msmtprc
	-unlink ~/.mbsyncrc
	ln -s ~/Dropbox/Fedora/system_setup/mbsync/.mbsyncrc ~/.mbsyncrc

link-git-config:
	-unlink ~/.gitconfig
	ln -s $(HOME)/git/dotfiles/.gitconfig $(HOME)/.gitconfig
