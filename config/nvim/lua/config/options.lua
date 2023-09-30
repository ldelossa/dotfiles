-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.relativenumber = false
opt.signcolumn = "number"
opt.expandtab = false
opt.shiftwidth = 4
opt.tabstop = 4

-- set c fileype for headers, not cpp
vim.g.c_syntax_for_h = 1

-- add commands to assist copying file and line numbers
vim.cmd('command! CopyDir let @+ = expand("%:p:h")')
vim.cmd('command! CopyPath let @+ = expand("%:p")')
vim.cmd('command! CopyPathLine let @+ = expand("%:p") . ":" . line(".")')
vim.cmd('command! CopyRel let @+ = expand("%")')
vim.cmd('command! CopyRelLine let @+ = expand("%"). ":" . line(".")')
