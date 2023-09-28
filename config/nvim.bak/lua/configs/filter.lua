local M = {}

local counters = {}

function M.filter_buffer(args)
    vim.cmd(":%!ag " .. args["args"])
    vim.cmd("set syntax=log")
end

function M.filter_buffer_tab(args)
    local tmp_buf = vim.api.nvim_create_buf(true, true)
    local cur_buf = vim.api.nvim_get_current_buf()
    local cur_buf_name = vim.api.nvim_buf_get_name(cur_buf)

    vim.api.nvim_buf_set_lines(tmp_buf, 0, -1, false, vim.api.nvim_buf_get_lines(cur_buf, 0, -1, false))

    vim.cmd(":%!ag " .. args["args"])
    vim.cmd("tabnew")

    if counters[cur_buf_name] == nil then
        counters[cur_buf_name] = 1
    else
        counters[cur_buf_name] = counters[cur_buf_name]+1
    end

    vim.api.nvim_buf_set_name(0, cur_buf_name .. ":filtered:" .. counters[cur_buf_name])


    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.api.nvim_buf_get_lines(cur_buf, 0, -1, false))
    vim.api.nvim_buf_set_lines(cur_buf, 0, -1, false, vim.api.nvim_buf_get_lines(tmp_buf, 0, -1, false))
    vim.api.nvim_buf_delete(tmp_buf, {force=true})
    vim.cmd("set syntax=log")
end

vim.api.nvim_create_user_command("FilterBuffer", M.filter_buffer, {
    nargs = 1,
})
vim.api.nvim_create_user_command("FilterBufferTab", M.filter_buffer_tab, {
    nargs = 1,
})
return M
