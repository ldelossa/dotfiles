configs := $(notdir $(wildcard ./config/*))
user_configs := $(addprefix /home/louis/.config/, $(configs))

default:
	@echo Usage:
	@echo make link-configs - link ./config dirs to home directory

link-configs: $(user_configs)

$(user_configs):
	-unlink $@
	ln -s $(subst /home/louis/.config,$(shell pwd)/config,$@) $@
