require'nvim-treesitter.configs'.setup{
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
        },
    },
    textobjects = { 
        enable = true 
    },
}
vim.api.nvim_command('set foldmethod=expr')
vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()') 

-- use treesitter to echo current function
-- vim.api.nvim_command('autocmd CursorHold,CursorMoved * lua print(require("nvim-treesitter").statusline())')
