local lib_panel = require('litee.lib.panel')
local M = {}

local opts = {noremap = true, silent=true}
vim.api.nvim_set_keymap("n", "<leader>tm", "<cmd>lua require('litee.lib.term').terminal()<cr>", opts)

function M.terminal()
    local buf = vim.api.nvim_create_buf(false, false)
    if buf == 0 then
        vim.api.nvim_err_writeln("failed to create terminal buffer")
        return
    end
    vim.api.nvim_buf_set_keymap(buf, 't', "<C-w>v", "<cmd>lua require('configs.terminal').terminal_vsplit()<cr>", opts)
    vim.api.nvim_buf_set_keymap(buf, 't', "<C-w>n", "<C-\\><C-n>", opts)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
    vim.cmd('botright split')
    vim.cmd('resize 15')
    local cur_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win, buf)
    vim.fn.termopen("/bin/zsh")
    lib_panel.toggle_panel_ctx(true, true)
    vim.api.nvim_set_current_win(cur_win)
end


function M.terminal_vsplit()
    local buf = vim.api.nvim_create_buf(false, false)
    if buf == 0 then
        vim.api.nvim_err_writeln("failed to create terminal buffer")
        return
    end
    vim.api.nvim_buf_set_keymap(buf, 't', "<C-w>v", "<cmd>lua require('configs.terminal').terminal_vsplit()<cr>", opts)
    vim.api.nvim_buf_set_keymap(buf, 't', "<C-w>n", "<C-\\><C-n>", opts)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
    vim.cmd('vsplit')
    vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buf)
    vim.fn.termopen("/bin/zsh")
end

return M
