configs := $(notdir $(wildcard ./config/*))
user_configs := $(addprefix $(HOME)/.config/, $(configs))

default:
	@echo Usage:
	@echo make link-configs 	- link ./config dirs to home directory
	@echo make link-zsh			- link zshrc and zsh.d directories
	@echo make link-gdb-config	- link .gdbinit to ~/.gdbinit

all: link-configs link-zsh link-gdb-config

link-configs: $(user_configs)

$(user_configs):
	-mkdir $(HOME)/.config
	-unlink $@
	ln -s $(subst $(HOME)/.config,$(shell pwd)/config,$@) $@

link-zsh:
	ln -s $(HOME)/git/dotfiles/zshrc $(HOME)/.zshrc
	ln -s $(HOME)/git/dotfiles/zsh.d $(HOME)/zsh.d

link-gdb-config:
	ln -s $(HOME)/git/dotfiles/gdb/.gdbinit $(HOME)/.gdbinit
