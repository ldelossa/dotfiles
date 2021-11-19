call plug#begin('~/.config/nvim/after')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
    Plug 'neovim/nvim-lspconfig'
    Plug 'mcchrish/nnn.vim'
    Plug 'ldelossa/vimdark'
    Plug 'rust-lang/rust.vim'
    Plug 'windwp/nvim-autopairs'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'akinsho/flutter-tools.nvim'
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
    Plug 'b3nj5m1n/kommentary'
    Plug 'famiu/feline.nvim'
    Plug 'phaazon/hop.nvim'
    Plug 'ldelossa/calltree.nvim'
call plug#end()
source $HOME/.config/nvim/lua/configs/vimdark.vim
source $HOME/.config/nvim/lua/configs/nnn.vim
lua require('configs.go-nvim')
lua require('configs.nvim-lsp')
lua require('configs.fzf')
lua require('configs.nvim-autopairs')
lua require('configs.flutter-tools')
lua require('configs.nvim-echo-diagnostics')
lua require('configs.lspkind')
lua require('configs.indent-blankline')
lua require('configs.nvim-gps')
lua require('configs.nvim-web-devicons')
lua require('configs.gitsigns')
lua require('configs.nvim-treesitter-textobjects')
lua require('configs.kommentary')
lua require('configs.feline')
lua require('configs.nvim-treesitter')
lua require('configs.hop-nvim')
lua require('configs.calltree')

" helpful abbreviations 
cnoreabbrev f FzfLua
cnoreabbrev g Gitsigns

