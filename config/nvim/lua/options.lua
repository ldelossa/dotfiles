local opt = vim.opt

-- update diffopt depending on term column count
-- this makes vim diff vertical if the terminal is narrow
local function update_diffopt()
	local columns = vim.api.nvim_get_option("columns")
	if columns < 120 then
		opt.diffopt:remove("vertical")
		opt.diffopt:append("horizontal")
	else
		opt.diffopt:remove("horizontal")
		opt.diffopt:append("vertical")
	end
end

update_diffopt()
opt.relativenumber = false
vim.opt.signcolumn = "yes"
opt.expandtab = false
opt.shiftwidth = 4
opt.tabstop = 4
opt.colorcolumn = "80"
vim.o.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.o.cmdheight = 0
vim.o.scrolloff = 5
vim.o.wrap = false
vim.o.foldlevel = 99
vim.o.updatetime = 300
vim.o.list = true

-- set c fileype for headers, not cpp
vim.g.c_syntax_for_h = 1

-- add commands to assist copying file and line numbers
vim.cmd('command! CopyDir let @+ = expand("%:p:h")')
vim.cmd('command! CopyPath let @+ = expand("%:p")')
vim.cmd('command! CopyPathLine let @+ = expand("%:p") . ":" . line(".")')
vim.cmd('command! CopyRel let @+ = expand("%")')
vim.cmd('command! CopyRelLine let @+ = expand("%"). ":" . line(".")')

-- set theme based on gnome's color-scheme settings
function set_dark_theme()
	vim.cmd("set background=dark")
end

function set_light_theme()
	vim.cmd("set background=light")
end

local function is_prefer_light_theme()
	-- Run the dconf command and capture the output
	local handle = io.popen("dconf read /org/gnome/desktop/interface/color-scheme")
	local result = handle:read("*a")
	handle:close()

	-- Trim any whitespace from the result
	result = string.gsub(result, "^%s*(.-)%s*$", "%1")

	-- Check the result and return true for 'prefer-light', false for 'prefer-dark'
	if result == "'prefer-light'" then
		return true
	elseif result == "'prefer-dark'" then
		return false
	else
		return nil
	end
end

if is_prefer_light_theme() then
	set_light_theme()
else
	set_dark_theme()
end
