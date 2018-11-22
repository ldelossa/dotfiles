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
	autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
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

" remap jump to last location 
nnoremap <C-F> <C-O>

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
	Plug 'Yggdroot/indentLine'
	Plug 'davidhalter/jedi-vim'
	Plug 'ervandew/supertab'
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
	Plug 'plytophogy/vim-virtualenv'
call plug#end()

" base-16 shell
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" lightlight configurations
let g:lightline = {
    \ 'colorscheme': 'Tomorrow_Night_Eighties',
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
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1
let g:SuperTabClosePreviewOnPopupClose = 1
map <leader>p :pc <CR>
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

" vim-go Configuration
let g:go_gocode_propose_source = 0 " parse binary for code completion
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
" let g:go_metalinter_autosave = 1
let g:go_metalinter_deadline = "5s"
let g:neocomplete#enable_at_startup = 1
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_test_timeout = "600s"
let g:go_decls_mode = 'fzf'

" vim-go key bindings and autocommands
augroup go
    autocmd!
    " emulate autobuild
    au BufWritePost *.go silent! :GoInstall
    au FileType go nmap <leader>b <Plug>(go-build)
    au FileType go nmap <leader>r <Plug>(go-run)
    au FileType go nmap <leader>i <Plug>(go-info)
    au FileType go nmap <leader>de <Plug>(go-deps)
    au FileType go nmap <leader>d <Plug>(go-doc)
    au FileType go nmap <leader>dv <Plug>(go-doc-vertical)
    au FileType go nmap <leader>db <Plug>(go-doc-browser)
    au FileType go nmap gd <Plug>(go-def)
    au FileType go nmap gds <Plug>(go-def-split)
    au FileType go nmap gdv <Plug>(go-def-vertical)
    au FileType go nmap gd; <Plug>(go-def-stack)
    au FileType go nmap gdd <Plug>(go-def-pop)
    au FileType go nmap gdp <Plug>(go-def-pop)
    au FileType go nmap gdc <Plug>(go-def-stack-clear)
    au FileType go nmap <leader>im <Plug>(go-implements) 
    au FileType go nmap <leader>R <Plug>(go-rename)
    au FileType go nmap <leader>cC <Plug>(go-callees)
    au FileType go nmap <leader>cc <Plug>(go-callers)
    au FileType go nmap <leader>D <Plug>(go-describe)
    au FileType go nmap <leader>cs <Plug>(go-callstack)
    au FileType go nmap <leader>cp <Plug>(go-channelpeers)
    au FileType go nmap <leader>rr <Plug>(go-referrers)
    au FileType go nmap <leader>p <Plug>(go-pointsto)
    au FileType go nmap <leader>l <Plug>(go-metalinter)
    au FileType go nmap <leader>a <Plug>(go-alternate-edit)
    au FileType go nmap <leader>as <Plug>(go-alternate-split)
    au FileType go nmap <leader>av <Plug>(go-alternate-vertical)
    au FileType go nmap <leader>e <Plug>(go-iferr)
    au FileType go nmap <leader>o :GoDecls <CR>
    au FileType go nmap <leader>oo :GoDeclsDir <CR>
    au FileType go nmap <leader>ii :GoImport 
    au FileType go nmap <leader>ia :GoImportAs 
    au FileType go nmap <leader>f :GoFillStruct <CR>
    au FileType go nmap <leader>at :GoAddTags <CR>
    au FileType go nmap <leader>t :GoTestFunc -v -race <CR>
    au FileType go nmap <leader>T :GoTest -v -race <CR>
    au FileType go nmap <leader>c :GoTestCompile <CR>
    au FileType go nmap <C-n> :cnext<CR>
    au FileType go nmap <C-p> :cprevious<CR>
    au FileType go nmap <C-a> :cclose<CR>
augroup END

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
map <C-O> :Files <CR>
nmap <C-B> :Buffers<cr>
nmap ; :Buffers<cr>
nmap <C-T> :Tags<cr>

" jedi-vim Confurations
let g:jedi#popup_on_dot=0
let g:jedi#completions_enabled=1
let g:jedi#goto_command = "gd"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"

" ALE configurations
noremap <leader>at :ALEToggle<CR>
let g:ale_fixers = {'javascript': ['eslint'], 'python': ['black'], 'c': ['clang-format', 'cquery'], 'cpp': ['clang-format', 'cquery']}
let g:ale_enabled = 0
highlight ALEError ctermbg=DarkRed
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

" vim-clang-format configuration
let g:clang_format#auto_format=1
let g:clang_format#style_options = { 
            \ "Standard" : "C++11",
            \ "IndentWidth" : 4,
            \ "UseTab" : "false",
            \ "AccessModifierOffset" : -2,
            \ "ColumnLimit" : 0 }
