" vim plugs
call plug#begin('~/.local/share/nvim/plugged')
    Plug 'neovim/nvim-lspconfig'
    Plug 'mcchrish/nnn.vim'
    Plug 'ldelossa/vimdark'
    Plug 'vim-ctrlspace/vim-ctrlspace'
    Plug 'rust-lang/rust.vim'
    Plug 'mattn/vim-gomod'
call plug#end()

source $HOME/.config/nvim/vimdark.vim
source $HOME/.config/nvim/ctrlspace.vim
source $HOME/.config/nvim/nnn.vim
