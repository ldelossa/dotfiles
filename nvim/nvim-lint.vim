lua << EOF
require('lint').linters_by_ft = {
  go = {'golangcilint',},
  markdown = {'markdownlint',},
}
EOF

au BufWritePost * lua require('lint').try_lint()
