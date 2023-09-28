require("echo-diagnostics").setup{
    show_diagnostic_number = true
}
vim.api.nvim_command('autocmd CursorHold * lua require("echo-diagnostics").echo_line_diagnostic()')
