if has('macunix')
    set shell=/usr/local/bin/zsh
else
    set shell=/usr/bin/zsh
endif

if has('macunix')
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

" general configurations
syntax on
filetype plugin indent on
set number
syntax on

" general configurations
syntax on
filetype plugin indent on
set number
set numberwidth=1
set backspace=2 
set updatetime=275
set timeoutlen=300
set autowrite
set noshowmode
set ignorecase
set smartcase
set incsearch
set lazyredraw
set showmatch
set viewoptions-=options
set tags+=.tags
let mapleader=" "
set nostartofline
set hidden
set conceallevel=2
set completeopt-=preview
set clipboard+=unnamed
set linebreak
set showcmd
set directory=$HOME/.cache/vim

" term shortcuts
if has("nvim")
    nnoremap <leader>tm :split term://zsh<CR>
else
    nnoremap <leader>tm :topleft term<CR>
    tmap <C-W>v <C-W>:vert term<CR>
    tmap <C-W>s <C-W>:term<CR>
endif

" remove highlights
nnoremap <leader>h :noh <CR>
" disable auto comments on next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" set vim as man pager
runtime ftplugin/man.vim 
set keywordprg=:Man

" don't mistype W as Window
:cabbrev W <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'w' : 'W')<CR>

" turn on code folding, defaults to all folds open
set foldmethod=syntax
set foldlevel=9999

" edit and source vimrc
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" copy buffer path commands
command! CopyDir let @+ = expand('%:p:h')
command! CopyPath let @+ = expand('%:p')
command! CopyPathLine let @+ = expand('%:p') . ":" . line(".")
nnoremap <leader>cp :let @+ = expand('%:p') . ":" . line(".")<CR>
command! CopyRel let @+ = expand('%')

" paste yank buffer
nnoremap <leader>py "0p

" Spacing
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set ai
set si
augroup spacing
	autocmd!
	autocmd FileType html setlocal shiftwidth=2 tabstop=2
	autocmd FileType javascript setlocal expandtab! shiftwidth=2 tabstop=2
	autocmd FileType Python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4
	autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" misc autoccmds
augroup misc
	autocmd!
	" In the quickfix window, <CR> is used to jump to the error under the
	" cursor, so undefine the mapping there.
	autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

	" Per default, netrw leaves unmodified buffers open. This autocommand
	" deletes netrw's buffer once it's hidden (using ':q', for example)
	autocmd FileType netrw setl bufhidden=delete
augroup END

" remap quickfix navigations
function! QuickFixToggle()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
             cclose
             return
		endif
	endfor

	copen | resize 10
endfunction

nnoremap <C-q> :call QuickFixToggle()<CR>

" Remap Buffer Switching
nnoremap gb :bnext<CR>
nnoremap bg :bprevious<CR>
nnoremap bd :bp\|bd #<CR>

" Remap split buffer navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" vim plugs
call plug#begin('~/.local/share/nvim/plugged')
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'mattn/vim-lsp-settings'
    Plug 'mcchrish/nnn.vim'
    Plug 'ldelossa/vimdark'
    Plug 'vim-ctrlspace/vim-ctrlspace'
    Plug 'rust-lang/rust.vim'
    Plug 'mattn/vim-gomod'
call plug#end()

let $BAT_THEME="1337"
function! DarkMode()
    colorscheme vimdark
endfunction

function! LightMode()
    colorscheme vimlight
endfunction

" use vimdark from 9pm to 10am
if strftime("%H") >= 21 || strftime("%H") <= 9
    call DarkMode()
else
    call LightMode()
endif

nnoremap <leader>lm :call LightMode() <CR>
nnoremap <leader>dm :call DarkMode() <CR>

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

" CtrlSpace configuration
augroup CtrlSpace
    let g:CtrlSpaceSetDefaultMapping = 0
    let g:CtrlSpaceDefaultMappingKey = ""
    nnoremap <silent> ' :CtrlSpace p<CR>
augroup END

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  nnoremap \ :Ag<SPACE> 
endif

" nnn configurations
let g:nnn#command = 'nnn -C'
let g:nnn#action = {
      \ '<C-h>': 'split',
      \ '<C-v>': 'vsplit' }
let $DISABLE_FILE_OPEN_ON_NAV=1
let $NNN_RESTRICT_NAV_OPEN=1
nnoremap <leader>nn :NnnPicker %:p:h<CR>
nnoremap <leader>n :NnnPicker<CR>
nnoremap <C-f> :NnnPicker -Po<CR>

" identify syntax highliting group under cursor
" see: https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
nmap <leader>hi :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
