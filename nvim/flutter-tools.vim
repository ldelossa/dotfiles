lua << EOF
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
EOF

hi FlutterClosingTag ctermbg=NONE ctermfg=242 cterm=italic
