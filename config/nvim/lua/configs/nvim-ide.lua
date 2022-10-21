require('ide').setup({
    icon_set = "codicons",
})

local opts = { silent = true }
vim.api.nvim_set_keymap("n", "<leader><leader>", ":Workspace Explorer Focus<cr>", opts)
