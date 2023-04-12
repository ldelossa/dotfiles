call plug#begin('~/.config/nvim/after')
    Plug 'nvim-treesitter/nvim-treesitter'  
    Plug 'neovim/nvim-lspconfig'
    Plug 'rust-lang/rust.vim'
    Plug 'windwp/nvim-autopairs'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    " Plug 'ibhagwan/fzf-lua'
    Plug 'seblj/nvim-echo-diagnostics'
    Plug 'onsails/lspkind-nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'SmiteshP/nvim-navic'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'numToStr/Comment.nvim'
    Plug 'ldelossa/gh.nvim'
    Plug 'rlane/pounce.nvim'
    Plug 'ruifm/gitlinker.nvim'
    Plug 'ldelossa/nightfox.nvim'
    Plug 'nvim-treesitter/playground'
    Plug 'pedrohdz/vim-yaml-folds'
    Plug 'ray-x/go.nvim'
    Plug 'ldelossa/buffertag'
    Plug 'mfussenegger/nvim-dap'
    Plug 'rcarriga/nvim-dap-ui'
    Plug 'ldelossa/nvim-dap-projects' 
    " Plug 'ldelossa/nvim-ide'
    Plug 'nvim-telescope/telescope-dap.nvim'
    Plug 'projekt0n/github-nvim-theme'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'rafamadriz/friendly-snippets'
    Plug 'dnlhc/glance.nvim'
    Plug 'rcarriga/nvim-notify'
    Plug 'https://gitlab.com/yorickpeterse/nvim-window.git'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
    Plug 'nvim-telescope/telescope-ui-select.nvim'
    Plug 'akinsho/git-conflict.nvim'
    " Plug 'fatih/vim-go'
call plug#end()
lua require('configs.buffer-resize')
" lua require('configs.fzf')
"" register FzfLua as vim.ui.select implementor
" lua vim.cmd("FzfLua register_ui_select")
lua require('configs.nvim-autopairs')
lua require('configs.nvim-echo-diagnostics')
lua require('configs.lspkind')
lua require('configs.indent-blankline')
lua require('configs.nvim-navic')
lua require('configs.nvim-web-devicons')
lua require('configs.gitsigns')
lua require('configs.nvim-treesitter-textobjects')
lua require('configs.nvim-treesitter')
lua require('configs.lualine')
lua require('configs.comment')
lua require('configs.pounce')
lua require('configs.gitlinker')
lua require('configs.go-nvim')
lua require('configs.buffertag')
lua require('configs.filter')
lua require('nvim-dap-projects').search_project_config()
lua require('configs.nvim-cmp')
lua require('configs.nvim-dap')
" lua require('configs.nvim-ide')
lua require('configs.glance')
lua require('configs.nvim-notify')
lua require('configs.nvim-window')
lua require('configs.telescope')
lua require('configs.github-theme')
lua require('configs.nvim-lsp')
lua require('configs.git-conflict')
lua require('configs.luasnips')
" load snippets from friendly-snippets
lua require("luasnip.loaders.from_vscode").lazy_load()
" source $HOME/.config/nvim/lua/configs/vim-go.vim

