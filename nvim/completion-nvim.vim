" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

let g:completion_enable_auto_popup = 0
let g:completion_enable_auto_signature = 0

imap <silent> <c-space> <Plug>(completion_trigger)

let g:completion_chain_complete_list = {
	    \'default' : [
	    \    {'complete_items': ['lsp', "path"]},
	    \]
	    \}
let g:completion_items_priority = {
        \ 'Field': 5,
        \ 'Function': 4,
        \}

autocmd BufEnter * lua require'completion'.on_attach()
