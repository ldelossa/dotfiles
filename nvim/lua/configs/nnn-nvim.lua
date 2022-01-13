local builtin = require("nnn").builtin
require("nnn").setup({
    explorer = {
        cmd = 'nnn -C'
    },
    picker = {
        cmd = 'nnn -C'
    },
	mappings = {
		{ "<C-n>t", builtin.open_in_tab },       -- open file(s) in tab
		{ "<C-n>s", builtin.open_in_split },     -- open file(s) in split
		{ "<C-n>v", builtin.open_in_vsplit },    -- open file(s) in vertical split
		{ "<C-n>p", builtin.open_in_preview },   -- open file in preview split keeping nnn focused
		{ "<C-n>c", builtin.copy_to_clipboard }, -- copy file(s) to clipboard
		{ "<C-n>w", builtin.cd_to_path },        -- cd to file directory
		{ "<C-n>e", builtin.populate_cmdline },  -- populate cmdline (:) with file(s)
	}
})

-- local opts = {noremap = true, silent = true}
-- vim.api.nvim_set_keymap('n', '<leader><leader>', ':NnnPicker %:p:h<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<leader>n', ':NnnPicker<CR>', opts)
