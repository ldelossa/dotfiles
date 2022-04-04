" nvim native LSP will do this
let g:go_code_completion_enabled = 0
let g:go_gopls_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_fmt_command = "goimports"
let g:go_mod_fmt_autosave = 1
let g:go_fmt_autosave = 1
let g:go_imports_autosave = 1
let g:go_diagnostics_level = 0

" handled by treesitter-textobjects
let g:go_textobj_enabled = 1

let g:go_test_show_name = 1
let g:go_doc_popup_window = 1
let g:go_def_mapping_enabled = 0

" linting
let g:go_metalinter_deadline = "60s"
let g:go_metalinter_command = "golangci-lint"

" turn off all highlighting
let go_highlight_string_spellcheck = 0
let go_highlight_format_strings = 0
let go_highlight_diagnostic_errors = 0
let go_highlight_diagnostic_warnings = 0
let go_highlight_debug = 0
let g:go_list_type_commands = {"GoFmt": ""}
