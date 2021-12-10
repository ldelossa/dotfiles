local opts = {noremap=true, silent=true}
vim.api.nvim_set_keymap("n", "<Up>", ":resize +5<cr>", opts)
vim.api.nvim_set_keymap("n", "<Down>", ":resize -5<cr>", opts)
vim.api.nvim_set_keymap("n", "<Left>", ":vert resize -5<cr>", opts)
vim.api.nvim_set_keymap("n", "<Right>", ":vert resize +5<cr>", opts)
