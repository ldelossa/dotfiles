" vim plugs
if has('nvim')
    call plug#begin('~/.local/share/nvim/plugged')
        Plug 'nvim-lua/completion-nvim'
        Plug 'neovim/nvim-lspconfig'
        Plug 'hrsh7th/nvim-compe'
        Plug 'mcchrish/nnn.vim'
        Plug 'ldelossa/vimdark'
        Plug 'vim-ctrlspace/vim-ctrlspace'
        Plug 'rust-lang/rust.vim'
        Plug 'mattn/vim-gomod'
    call plug#end()
    source $HOME/.config/nvim/nvim-lsp.vim
    source $HOME/.config/nvim/completion-nvim.vim
    source $HOME/.config/nvim/vimdark.vim
    source $HOME/.config/nvim/ctrlspace.vim
    source $HOME/.config/nvim/nnn.vim
else 
    call plug#begin('~/.local/share/vim/plugged')
        Plug 'prabirshrestha/vim-lsp'
        Plug 'prabirshrestha/asyncomplete.vim'
        Plug 'prabirshrestha/asyncomplete-lsp.vim'
        Plug 'mattn/vim-lsp-settings'
        Plug 'mcchrish/nnn.vim'
        Plug 'ldelossa/vimdark'
        Plug 'vim-ctrlspace/vim-ctrlspace'
        Plug 'rust-lang/rust.vim'
        Plug 'mattn/vim-gomod'
    call plug#end()
    source $HOME/.config/nvim/vim-lsp.vim
    source $HOME/.config/nvim/vimdark.vim
    source $HOME/.config/nvim/ctrlspace.vim
    source $HOME/.config/nvim/nnn.vim
endif
