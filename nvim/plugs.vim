" vim plugs
if has('nvim')
    call plug#begin('~/.local/share/nvim/plugged')
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
        Plug 'neovim/nvim-lspconfig'
        Plug 'mcchrish/nnn.vim'
        Plug 'ldelossa/vimdark'
        Plug 'rust-lang/rust.vim'
        Plug 'windwp/nvim-autopairs'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-lua/popup.nvim'
        Plug 'akinsho/flutter-tools.nvim'
    "    Plug 'mfussenegger/nvim-lint'
        Plug 'ruanyl/vim-gh-line'
        Plug 'ibhagwan/fzf-lua'
        Plug 'vijaymarupudi/nvim-fzf'
        Plug 'seblj/nvim-echo-diagnostics'
        Plug 'onsails/lspkind-nvim'
        Plug 'lukas-reineke/indent-blankline.nvim'
        Plug 'ray-x/go.nvim'
        Plug 'SmiteshP/nvim-gps'
        Plug 'kyazdani42/nvim-web-devicons'
        Plug 'lewis6991/gitsigns.nvim'
        Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    call plug#end()
    source $HOME/.config/nvim/go-nvim.lua
    source $HOME/.config/nvim/nvim-treesitter.lua
    source $HOME/.config/nvim/nvim-lsp.lua
    source $HOME/.config/nvim/vimdark.vim
    source $HOME/.config/nvim/fzf.lua
    source $HOME/.config/nvim/nnn.vim
    source $HOME/.config/nvim/nvim-autopairs.lua
    source $HOME/.config/nvim/flutter-tools.lua
    "" source $HOME/.config/nvim/nvim-lint.lua
    source $HOME/.config/nvim/nvim-echo-diagnostics.lua
    source $HOME/.config/nvim/lspkind.lua
    source $HOME/.config/nvim/indent-blankline.lua
    source $HOME/.config/nvim/nvim-gps.lua
    source $HOME/.config/nvim/nvim-web-devicons.lua
    source $HOME/.config/nvim/statusline.lua
    source $HOME/.config/nvim/gitsigns.lua
    source $HOME/.config/nvim/nvim-treesitter-textobjects.lua
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
