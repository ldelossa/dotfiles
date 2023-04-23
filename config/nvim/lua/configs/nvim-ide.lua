require('ide').setup({
    icon_set = "codicon",
    components = {
        Explorer = {
            show_file_permissions = false
        },
        BufferList = {
            default_height = 5,
        },
        TerminalBrowser = {
            default_height = 5
        },
    },
    workspaces = {
        -- which panels to open by default, one of: 'left', 'right', 'both', 'none'
        auto_open = 'none',
    },
})

local opts = { silent = true }
vim.api.nvim_set_keymap("n", "<leader><leader>", ":Workspace Explorer Focus<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>tm", ":Workspace TerminalBrowser New<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>t", ":Workspace TerminalBrowser Focus<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>o", ":Workspace Outline Focus<cr>", opts)
