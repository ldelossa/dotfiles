# environment vars
export SHELL="/bin/zsh"
export GOPATH=~/git/gopath
export GOBIN=~/git/gopath/bin
export GOSRC=~/git/gopath/src/
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:~/.local/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/protoc-3.14.0/bin
export PATH=$PATH:/usr/lib/cargo/bin/
export PATH=$PATH:/Library/PostgreSQL/11/bin
export PATH=$PATH:/usr/local/flutter/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/goblog/bin
export PATH=$PATH:/opt/Lens
export PATH=$PATH:/home/louis/.platformio/penv/bin
export PATH=$PATH:/usr/local/zig
export PATH=$PATH:/home/louis/git/lua/lua-language-server/bin
export KEYTIMEOUT=1
export CC=/usr/bin/clang
export CCX=/usr/bin/clang++
export EDITOR='nvim --listen ~/.cache/nvim/nvim-$RANDOM.sock'
export NNN_PLUG='o:fzopen;c:chksum;d:diffs;h:hexview;s:suedit;l:-_git log'
export BAT_THEME='1337'
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export PATH="$PATH":"/usr/local/flutter/.pub-cache/bin"
export FZF_DEFAULT_OPTS='--color=bw --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up'
export CHROME_EXECUTABLE=chromium-browser

# hack to make java apps work in sway
# see: https://github.com/swaywm/sway/issues/595
export _JAVA_AWT_WM_NONREPARENTING=1

# set manpager to neovim
export MANPAGER='nvim +Man!'

# Set CDPATH
export CDPATH=~/:~/vmmnt/:~/.config/nvim/after:~/git:~/git/go:~/git/gopath/src:~/git/gopath/src/github.com:~/git/gopath/src/github.com/ldelossa:~/.local/share/nvim/site/pack/deps/opt
