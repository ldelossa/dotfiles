local mappings = { 
    { "<C-T>", "tabedit" }, -- open file in tab
    { "<C-S>", "split" }, -- open file in split
    { "<C-V>", "vsplit" }, -- open file in vertical split
}
local cfg = {
	explorer = {
		cmd = "nnn", -- command overrride (-p and -F1 flags are implied, -a flag is invalid!)
		width = 24, -- width of the vertical split
		session = "", -- or global/local/shared
	},
	picker = {
		cmd = "nnn", -- command override (-p flag is implied)
		style = {
			width = 0.9, -- width in percentage of the viewport
			height = 0.8, -- height in percentage of the viewport
			xoffset = 0.5, -- xoffset in percentage
			yoffset = 0.5, -- yoffset in percentage
			border = "single" -- border decoration e.g. "rounded"(:h nvim_open_win)
		},
		session = "", -- or global/local/shared
	},
	replace_netrw = nil, -- or explorer/picker
	mappings = mappings, -- table containing mappings, see below
	windownav = "<C-w>j", -- window movement mapping to navigate out of nnn
}
require("nnn").setup(cfg)

local opts = { silent=true }
vim.api.nvim_set_keymap("n", "<leader><leader>", "<cmd>NnnPicker %:p:h<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>NnnPicker<CR>", opts)
