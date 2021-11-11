require'hop'.setup()

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', 'f', ':HopChar1CurrentLine<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>hw', ':HopWord<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>hl', ':HopLine<cr>', opts)
