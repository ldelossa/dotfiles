require("flutter-tools").setup{
   widget_guides = {
      enabled = true,
   },
   closing_tags = {
      highlight = "FlutterClosingTag",
      prefix = "~ ", -- character to use for close tag e.g. > Widget
      enabled = true -- set to false to disable
   }
} -- use defaults

vim.api.nvim_command('hi FlutterClosingTag ctermbg=NONE ctermfg=241 cterm=italic')
