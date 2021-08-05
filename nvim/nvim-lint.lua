require('lint').linters_by_ft = {
  go = {'golangcilint',},
  markdown = {'markdownlint',},
}
vim.api.nvim_command("au BufWritePost * lua require('lint').try_lint()")

