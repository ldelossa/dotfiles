" shell options
set shell=/usr/local/bin/zsh
set t_Co=256 " 256 color mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

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
set conceallevel=0
set mouse=a
set completeopt-=preview
nnoremap <leader>hh :noh <CR>
" disable auto comments on next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" turn on code folding, defaults to all folds open
set foldmethod=syntax
set foldlevel=9999

" edit and source vimrc
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Spacing
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set ai
set si
set wrap
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

	copen | resize 5
endfunction

nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>
nnoremap <C-a> :call QuickFixToggle()<CR>

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
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'itchyny/lightline.vim'
    Plug 'w0rp/ale'
    Plug 'jiangmiao/auto-pairs'
    Plug 'chriskempson/base16-vim'
    Plug 'davidhalter/jedi-vim'
    Plug 'majutsushi/tagbar'
    Plug 'justmao945/vim-clang'
    Plug 'rhysd/vim-clang-format'
    Plug 'alvan/vim-closetag'
    Plug 'tpope/vim-commentary'
    Plug 'maxbrunsfeld/vim-emacs-bindings'
    Plug 'nvie/vim-flake8'
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-rhubarb'
    Plug 'tpope/vim-sensible'
    Plug 'kshenoy/vim-signature'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-vinegar'
    Plug 'plytophogy/vim-virtualenv', { 'for': 'python' }
    Plug 'tpope/vim-eunuch'
    Plug 'mcchrish/nnn.vim'
    Plug 'nightsense/snow'
    Plug 'rizzatti/dash.vim'
    Plug 'adrienverge/yamllint'
    Plug 'chaoren/vim-wordmotion'
    Plug 'ayu-theme/ayu-vim'
    Plug 'logico-software/typewriter'
    Plug 'ldelossa/vimdark'
    Plug 'octol/vim-cpp-enhanced-highlight'
    Plug 'nathanaelkane/vim-indent-guides'
call plug#end()

colorscheme vimdark

function! DarkMode()
    colorscheme vimdark
endfunction

function! LightMode()
    colorscheme vimlight
endfunction

nnoremap <leader>lm :call LightMode() <CR>
nnoremap <leader>dm :call DarkMode() <CR>

" base-16 shell
" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif

" lightlight configurations
let g:lightline = {
    \ 'colorscheme': 'nord',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'gitbranch', 'readonly', 'filename', 'modified', 'gostatus' ] ]
	\ },
	\ 'component_function': {
	\   'gitbranch': 'fugitive#head',
    \   'gostatus': 'go#statusline#Show'
	\ },
	\ 'component': {
	\   'filename': '%f'
	\ },
	\ }

" netrw configurations
let g:netrw_liststyle=3
let g:netrw_altv=1
nnoremap <leader>e :Ex <CR>
nnoremap <leader>v :Vex <CR>
nnoremap <leader>h :Hex <CR>

" SuperTab configurations
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1
" let g:SuperTabClosePreviewOnPopupClose = 1
" map <leader>p :pc <CR>
" let g:SuperTabCrMapping = 1

" CloseTag configurations
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
let g:closetag_filetypes = 'html,xhtml,phtml,js'
let g:closetag_xhtml_filetypes = 'xhtml,jsx,js'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

" Airliner configurations
let g:airline_theme='papercolor'
" let g:airline_theme = "hybrid"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Omnicomplete configurations
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" vim-go configuration
" let g:go_gocode_propose_source = 0 " parse binary for code completion
let g:go_disable_autoinstall = 0
let g:go_highlight_functions = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_build_constraints = 1
let g:go_term_enabled = 1
let g:go_term_mode = "split"
let g:go_term_height = 13
let g:go_metalinter_command = "golangci-lint"
" let g:go_metalinter_autosave = 1
let g:go_metalinter_deadline = "5s"
let g:neocomplete#enable_at_startup = 1
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_test_timeout = "600s"
let g:go_decls_mode = 'fzf'
let g:go_test_show_name = 1
let g:go_fmt_experimental = 1
let g:go_def_mode = 'godef'

" vim-go key bindings and autocommands
augroup go
    autocmd!
    au filetype go nmap <leader>b <plug>(go-build)
    au filetype go nmap <leader>r <plug>(go-run)
    au filetype go nmap <leader>i <plug>(go-info)
    au filetype go nmap <leader>de <plug>(go-deps)
    au filetype go nmap <leader>d <plug>(go-doc)
    au filetype go nmap <leader>dv <plug>(go-doc-vertical)
    au filetype go nmap <leader>db <plug>(go-doc-browser)
    au filetype go nmap gd <plug>(go-def)
    au filetype go nmap gds <plug>(go-def-split)
    au filetype go nmap gdv <plug>(go-def-vertical)
    au filetype go nmap gd; <plug>(go-def-stack)
    au filetype go nmap gdd <plug>(go-def-pop)
    au filetype go nmap gdp <plug>(go-def-pop)
    au filetype go nmap gdc <plug>(go-def-stack-clear)
    au filetype go nmap <leader>im <plug>(go-implements) 
    au filetype go nmap <leader>R <plug>(go-rename)
    au filetype go nmap <leader>cc <plug>(go-callees)
    au filetype go nmap <leader>cc <plug>(go-callers)
    au filetype go nmap <leader>d <plug>(go-describe)
    au filetype go nmap <leader>cs <plug>(go-callstack)
    au filetype go nmap <leader>cp <plug>(go-channelpeers)
    au filetype go nmap <leader>rr <plug>(go-referrers)
    au filetype go nmap <leader>p <plug>(go-pointsto)
    au filetype go nmap <leader>l <plug>(go-metalinter)
    au filetype go nmap <leader>a <plug>(go-alternate-edit)
    au filetype go nmap <leader>as <plug>(go-alternate-split)
    au filetype go nmap <leader>av <plug>(go-alternate-vertical)
    au filetype go nmap <leader>e <plug>(go-iferr)
    au filetype go nmap <leader>oo :GoDecls <cr>
    au filetype go nmap <leader>o  :GoDeclsDir <cr>
    au filetype go nmap <leader>ii :GoImport 
    au filetype go nmap <leader>ia :GoImportAs 
    au filetype go nmap <leader>f :GoFillStruct <cr>
    au filetype go nmap <leader>at :GoAddTags <cr>
    au filetype go nmap <leader>t :GoTestFunc -v -race <cr>
    au filetype go nmap <leader>T :GoTest -v -race <cr>
    au filetype go nmap <leader>c :GoTestCompile <cr>
    inoremap <C-Space> <C-x><C-o>
    inoremap <C-@> <C-Space>
augroup end

" TagBar gotags configuration
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

" TagBar configurations
map <leader>2 :TagbarToggle <CR>

" FZF configuration
map <C-G> :GFiles <CR>
map <C-F> :Files <CR>
nmap <C-B> :Buffers<cr>
nmap ; :Buffers<cr>
nmap <C-T> :Tags<cr>
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Visual'],
  \ 'fg+':     ['fg', 'Visual'],
  \ 'bg+':     ['bg', 'Visual'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
if has('nvim') || has('gui_running')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2
endif

" jedi-vim Confurations
let g:jedi#popup_on_dot=0
let g:jedi#completions_enabled = 1
let g:jedi#goto_command = "gd"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>c"
let g:jedi#force_py_version = 3

" ALE configurations
noremap <leader>al :ALEToggle<CR>
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 0
let g:ale_list_window_size = 5
let g:ale_fixers = {'javascript': ['eslint'], 'python': ['black'], 'c': ['clang-format', 'cquery'], 'cpp': ['clang-format', 'cquery']}
let g:ale_enabled = 0
highlight ALEError ctermfg=196 
highlight ALEWarning ctermfg=110
augroup ale
    autocmd!
    autocmd FileType python map <leader>f :ALEFix <CR>
    autocmd FileType javascript map <leader>f :ALEFix <CR>
augroup END

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  nnoremap \ :Ag<SPACE> 
endif

" vim-clang configuration
let g:clang_auto = 0
let g:clang_diagsopt = '' 

" vim-clang-format configuration
let g:clang_format#auto_format = 1
let g:clang_format#style_options = {
            \ "BasedOnStyle" : "LLVM",
            \ "IndentWidth" : 4,
            \ "SpaceAfterCStyleCast": "true"}

" nnn configurations
let g:nnn#action = {
      \ '<C-h>': 'split',
      \ '<C-v>': 'vsplit' }
let $DISABLE_FILE_OPEN_ON_NAV=1
let $NNN_RESTRICT_NAV_OPEN=1

" identify syntax highliting group under cursor
" see: https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" clag_complete configurations
let g:clang_library_path='/usr/local/lib/libclang.dylib'
