syntax on
colorscheme PaperColor
execute pathogen#infect()
filetype plugin indent on
set number
set backspace=2 " make backspace work like most other apps
set updatetime=250
set autowrite
set background=light
set timeoutlen=300
set t_Co=256 " 256 color mode
set shell=/usr/local/bin/zsh
set tags+=.tags
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
let mapleader=" "
set nostartofline
nnoremap <C-F> <C-O>
" In the quickfix window, <CR> is used to jump to the error under the
" cursor, so undefine the mapping there.
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" base-16 shell
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" netrw Configurations
let g:netrw_liststyle=3
let g:netrw_altv=1
map <leader>e :Ex <CR>
map <leader>v :Vex <CR>
map <leader>h :Hex <CR>

" SuperTab Configurations
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1
let g:SuperTabClosePreviewOnPopupClose = 1
map <leader>p :pc <CR>
" let g:SuperTabCrMapping = 1

" CloseTag Configurations
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
let g:closetag_filetypes = 'html,xhtml,phtml,js'
let g:closetag_xhtml_filetypes = 'xhtml,jsx,js'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

" Remap Buffer Switching
nnoremap gb :bnext<CR>
nnoremap bg :bprevious<CR>
nnoremap bd :bp\|bd #<CR>

" Airliner Configurations
let g:airline_theme='papercolor'
" let g:airline_theme = "hybrid"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Omnicomplete Configurations
" inoremap <S-TAB> <C-X><C-O>
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Spacing
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType Python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
set viewoptions-=options

" vim-go Configuration
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
autocmd FileType go map <leader>b :GoBuild <CR>
autocmd FileType go map <leader>r :GoRun <CR>
au FileType go nmap <leader>RT <Plug>(go-run-tab)
autocmd FileType go map <leader>l :GoMetaLinter <CR>
autocmd FileType go nmap <leader>R :GoRename <CR>
autocmd FileType go map <leader>o :GoDecls <CR>
autocmd FileType go map <leader>O :GoDeclsDir <CR>
autocmd FileType go map <leader>d :GoDoc <CR>
autocmd FileType go map <leader>I :GoInfo <CR>
autocmd FileType go map <leader>e :GoIfErr <CR>
autocmd FileType go map <leader>ii :GoImport 
autocmd FileType go map <leader>ia :GoImportAs 
autocmd FileType go map <leader>f :GoFillStruct <CR>
autocmd FileType go map <leader>t :GoTestFunc -v -race <CR>
autocmd FileType go map <leader>T :GoTest -v -race <CR>
autocmd FileType go map <leader>c :GoTestCompile <CR>
autocmd FileType go map <leader>at :GoAddTags <CR>
autocmd FileType go map <C-n> :cnext<CR>
autocmd FileType go map <C-m> :cprevious<CR>
autocmd FileType go nnoremap <leader>a :cclose<CR>

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

" Remap split buffer navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" CTRLP configurations
" let g:ctrlp_reuse_window = 'NERD'
" let g:ctrlp_use_caching = 1
" let g:ctrlp_clear_cache_on_exit = 0
" let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
" set runtimepath^=~/.vim/bundle/ctrlp.vim
" map <C-O> :CtrlP <CR>
" " nmap <C-B> :CtrlPBuffer<cr>
" nmap <C-T> :CtrlPTag<cr>

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
map <leader>at :ALEToggle<CR>
let g:ale_fixers = {'javascript': ['eslint'], 'python': ['black'], 'c': ['clang-format']}
autocmd FileType python map <leader>f :ALEFix <CR>
autocmd FileType javascript map <leader>f :ALEFix <CR>
let g:ale_enabled = 0
highlight ALEError ctermbg=DarkRed
" let g:ale_fix_on_save = 1

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag --literal --path-to-ignore ~/.config/git/ignore --files-with-matches --nocolor --hidden --ignore .git -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" vim-clang-format configuration
let g:clang_format#auto_format=1
let g:clang_format#style_options = { 
            \ "Standard" : "C++11",
            \ "IndentWidth" : 4,
            \ "UseTab" : "false",
            \ "AccessModifierOffset" : -2,
            \ "ColumnLimit" : 0 }

" c++ language server configurations
function LC_C_maps()
	if has_key(g:LanguageClient_serverCommands, &filetype)
		nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
	endif
endfunction

autocmd FileType cpp call LC_C_maps()
autocmd FileType hpp call LC_C_maps()
autocmd FileType c call LC_C_maps()
autocmd FileType h call LC_C_maps()

let g:LanguageClient_diagnosticsEnable=0

" vim plugs
call plug#begin('~/.local/share/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
call plug#end()
