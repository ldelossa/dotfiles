# environment vars 
export GOPATH=~/git/gopath
export GOBIN=~/git/gopath/bin
export GOSRC=~/git/gopath/src/
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/protoc-3.14.0/bin
export PATH=$PATH:/usr/lib/cargo/bin/
export PATH=$PATH:/Library/PostgreSQL/11/bin
export PATH=$PATH:/usr/local/flutter/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/goblog/bin
export PATH=$PATH:/opt/Lens
export KEYTIMEOUT=1
export CC=/usr/bin/clang
export CCX=/usr/bin/clang++
export EDITOR=nvim
export NNN_PLUG='o:fzopen;c:chksum;d:diffs;h:hexview;s:suedit;l:-_git log'
export BAT_THEME='1337'
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export PATH="$PATH":"/usr/local/flutter/.pub-cache/bin"
export FZF_DEFAULT_OPTS='--color=bw --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up'
export CHROME_EXECUTABLE=chromium-browser

# Set CDPATH
cdpath=(~/vmmnt/ ~/git ~/git/go ~/git/gopath/src ~/git/gopath/src/github.com ~/git/gopath/src/github.com/ldelossa)
