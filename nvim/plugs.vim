call plug#begin('~/.config/nvim/after')
    Plug 'nvim-treesitter/nvim-treesitter'  
    Plug 'neovim/nvim-lspconfig'
    Plug 'ldelossa/vimdark'
    Plug 'rust-lang/rust.vim'
    Plug 'windwp/nvim-autopairs'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'akinsho/flutter-tools.nvim'
    Plug 'ibhagwan/fzf-lua'
    Plug 'vijaymarupudi/nvim-fzf'
    Plug 'seblj/nvim-echo-diagnostics'
    Plug 'onsails/lspkind-nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'SmiteshP/nvim-gps'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'luukvbaal/nnn.nvim'
    Plug 'numToStr/Comment.nvim'
    Plug 'ldelossa/litee.nvim'
    Plug 'ldelossa/litee-filetree.nvim'
    Plug 'ldelossa/litee-symboltree.nvim'
    Plug 'ldelossa/litee-calltree.nvim'
    Plug 'ldelossa/litee-bookmarks.nvim'
    Plug 'Pocco81/HighStr.nvim'
    Plug 'rlane/pounce.nvim'
    Plug 'mtdl9/vim-log-highlighting'
    Plug 'ruifm/gitlinker.nvim'
    Plug 'ldelossa/nightfox.nvim'
    Plug 'nvim-treesitter/playground'
    Plug 'pedrohdz/vim-yaml-folds'
    Plug 'ray-x/go.nvim'
    Plug 'fatih/vim-go'
call plug#end()
lua require('configs.buffer-resize')
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
lua require('configs.nvim-treesitter')
lua require('configs.litee')
lua require('configs.vimdark')
lua require('configs.lualine')
lua require('configs.nnn-nvim')
lua require('configs.comment')
lua require('configs.terminal')
lua require('configs.highstr')
lua require('configs.pounce')
lua require('configs.gitlinker')
" lua require('configs.go-nvim')
source $HOME/.config/nvim/lua/configs/vim-go.vim

" helpful abbreviations 
cnoreabbrev f FzfLua
