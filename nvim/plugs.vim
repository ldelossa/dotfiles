" vim plugs
if has('nvim')
    call plug#begin('~/.local/share/nvim/plugged')
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
        Plug 'neovim/nvim-lspconfig'
        Plug 'mcchrish/nnn.vim'
        Plug 'ldelossa/vimdark'
        Plug 'rust-lang/rust.vim'
        Plug 'mattn/vim-gomod'
        Plug 'windwp/nvim-autopairs'
        Plug 'junegunn/fzf.vim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'akinsho/flutter-tools.nvim'
        Plug 'mfussenegger/nvim-lint'
        Plug 'ruanyl/vim-gh-line'
        Plug 'simrat38/symbols-outline.nvim'
    call plug#end()
    source $HOME/.config/nvim/nvim-lsp.lua
    source $HOME/.config/nvim/nvim-lsp-diag-echo.lua
    source $HOME/.config/nvim/nvim-treesitter.lua
    source $HOME/.config/nvim/vimdark.vim
    source $HOME/.config/nvim/fzf.vim
    source $HOME/.config/nvim/nnn.vim
    source $HOME/.config/nvim/nvim-autopairs.lua
    source $HOME/.config/nvim/flutter-tools.lua
    source $HOME/.config/nvim/nvim-lint.lua
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
