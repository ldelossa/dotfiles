local M = {}
function M.filter_buffer(args)
    vim.cmd(":%!grep " .. args["args"])
end
function M.filter_buffer_tab(args)
    local tmp_buf = vim.api.nvim_create_buf(true, true)
    local cur_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(tmp_buf, 0, -1, false, vim.api.nvim_buf_get_lines(cur_buf, 0, -1, false))
    vim.cmd(":%!grep " .. args["args"])
    vim.cmd("tabnew")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.api.nvim_buf_get_lines(cur_buf, 0, -1, false))
    vim.api.nvim_buf_set_lines(cur_buf, 0, -1, false, vim.api.nvim_buf_get_lines(tmp_buf, 0, -1, false))
    vim.api.nvim_buf_delete(tmp_buf, {force=true})
end

vim.api.nvim_create_user_command("FilterBuffer", M.filter_buffer, {
    nargs = 1,
})
vim.api.nvim_create_user_command("FilterBufferTab", M.filter_buffer_tab, {
    nargs = 1,
})
return M
