" VIMLSP configurations
let g:lsp_semantic_enabled = 1
let g:lsp_document_highlight_enabled = 0
if has('nvim')
    let g:lsp_preview_float = 1
    let g:lsp_diagnostics_virtual_text_prefix = " ‣ "
    let g:lsp_diagnostics_virtual_text_enabled = 0
else 
    let g:lsp_preview_float = 0
endif
let g:lsp_preview_doubletap = [function('lsp#ui#vim#output#closepreview')]
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_signs_error = {'text': '🄴'}
let g:lsp_diagnostics_signs_warning = {'text': '🅆'}
let g:lsp_diagnostics_signs_hint = {'text': '🄷'}
let g:lsp_diagnostics_signs_info = {'text': '🄸'}
let g:lsp_document_code_action_signs_hint = {'text': '🄰'}
let g:lsp_log_file = expand('~/.cache/vim/vim-lsp.log')
let g:asyncomplete_auto_popup = 0
let g:lsp_diagnostics_echo_delay = 200
let g:lsp_diagnostics_highlights_delay = 200
let g:lsp_diagnostics_signs_delay = 200
let g:lsp_document_code_action_signs_delay = 200
let g:lsp_document_highlight_delay = 200
let g:lsp_signature_help_enabled = 0
augroup VIMLSP
    if has("nvim-0.5.0") || has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      set signcolumn=number
    endif
    nnoremap gd  :LspDefinition<CR>
    nnoremap gdv :LspDefinition -vsplit<CR>
    nnoremap gds :LspDefinition -split<CR>
    nnoremap gi  :LspImplementation<CR>
    nnoremap <leader>r :LspRename<CR>
    nnoremap <leader>i :LspHover<CR>
    nnoremap <leader>u :LspReferences<CR>
    nnoremap <leader>a :LspCodeAction<CR>
    nnoremap <leader>l :LspCodeLens<CR>
    nnoremap <C-n> :LspNextDiagnostic<CR>
    nnoremap <C-p> :LspPreviousDiagnostic<CR>
    imap <C-@> <Plug>(asyncomplete_force_refresh)
    imap <c-space> <Plug>(asyncomplete_force_refresh)
    autocmd BufWritePre *.go silent LspDocumentFormatSync
    autocmd BufWritePre *.go silent :LspCodeActionSync source.organizeImports
augroup END
let g:lsp_settings = {
 \  'efm-langserver': {
 \    'allowlist': ['markdown', 'yaml', 'dockerfile', 'json'],
 \    'disabled': 0,
 \   },
 \}

