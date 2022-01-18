require'pounce'.setup{
  accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
  multi_window = true,
  debug = false,
}

local opts = { silent = true }
vim.api.nvim_set_keymap("n", "s",   "<cmd>Pounce<CR>", opts)
vim.api.nvim_set_keymap("v", "s",   "<cmd>Pounce<CR>", opts)
vim.api.nvim_set_keymap("o", "gs",  "<cmd>Pounce<CR>", opts)
