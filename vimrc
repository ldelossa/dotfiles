" shell options
set t_Co=256 " 256 color mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

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

" set copy and paste for wayland envs
if $XDG_SESSION_TYPE == 'wayland'
    xnoremap yy y:call system("wl-copy", @")<cr>
    nnoremap pp :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
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

" vim8 term settings
nnoremap <leader>tm :below term <cr>

" remove highlights
nnoremap <leader>h :noh <CR>
" disable auto comments on next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" set vim as man pager
runtime ftplugin/man.vim 
set keywordprg=:Man

" don't mistype W as Window
:cabbrev W <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'w' : 'W')<CR>

" remap nnn to open in current directory
nnoremap <leader>nn :NnnPicker %:p:h<CR>
nnoremap <leader>n :NnnPicker<CR>

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
    Plug 'mcchrish/nnn.vim'
    Plug 'itchyny/lightline.vim'
    Plug 'w0rp/ale'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'ldelossa/vimdark'
    Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'majutsushi/tagbar'
    Plug 'maxbrunsfeld/vim-emacs-bindings'
    Plug 'airblade/vim-gitgutter'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-rhubarb'
    Plug 'tpope/vim-sensible'
    Plug 'kshenoy/vim-signature'
    Plug 'chaoren/vim-wordmotion'
    Plug 'machakann/vim-sandwich'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release'}
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'josa42/vim-lightline-coc'
call plug#end()

function! DarkMode()
    let $BAT_THEME="1337"
    colorscheme vimdark
endfunction

function! LightMode()
    let $BAT_THEME="GitHub"
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

" lightlight configurations
let g:lightline = {
    \ 'colorscheme': 'nord',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'gitbranch', 'readonly', 'filename', 'modified'], 
    \             ['gostatus', 'coc_errors', 'coc_warnings', 'coc_ok', 'coc_status' ]]
	\ },
	\ 'component_function': {
	\   'gitbranch': 'fugitive#head',
    \   'gostatus': 'go#statusline#Show'
	\ },
	\ 'component': {
	\   'filename': '%f'
	\ },
	\ }
call lightline#coc#register()

let g:neocomplete#enable_at_startup = 1

" vim-go configuration
let g:go_code_completion_enabled = 0 " coc-go will provide completion
let g:go_doc_keywordprg_enabled = 0
let g:go_def_mapping_enabled = 0
let g:go_gopls_enabled = 0
let g:go_mod_fmt_autosave = 0
let g:go_fmt_autosave = 0
let g:go_term_enabled = 1
let g:go_term_mode = "split"
let g:go_term_height = 10
let g:go_term_exit = 1
let g:go_metalinter_deadline = "5s"
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_list_height = 10
let g:go_test_timeout = "600s"
let g:go_decls_mode = 'fzf'
let g:go_test_show_name = 1
let g:go_doc_popup_window = 1
let g:go_rename_command = ''
let g:go_term_close_on_exit = 1

augroup go
    autocmd!
    au filetype go nmap <leader>b   <plug>(go-build)
    au filetype go nmap <leader>rr  <plug>(go-run)
    au filetype go nmap <leader>t   :GoTestFunc! -v -race <cr>
    au filetype go nmap <leader>T   :GoTest! -v -race <cr>
    au filetype go nmap <leader>c   :GoTestCompile <cr>
    au filetype go nmap <leader>db  <plug>(go-doc-browser)
    au filetype go nmap <leader>l   <plug>(go-metalinter)
    au filetype go nmap <leader>ii  :GoImport 
    au filetype go nmap <leader>ia  :GoImportAs 
    au filetype go nmap <leader>at  :GoAddTags <cr>
augroup end

augroup CoC
    autocmd!

	if has('nvim')
	  inoremap <silent><expr> <c-space> coc#refresh()
	else
	  inoremap <silent><expr> <c-@> coc#refresh()
	endif

    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
    autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
    nmap <silent> gd    <Plug>(coc-definition)
    nmap <silent> gdd   <Plug>(coc-declaration)
    nmap <silent> gt    <Plug>(coc-type-definition)
    nmap <silent> gi    <Plug>(coc-implementation)
    nmap <silent> <leader>u     <Plug>(coc-references-used)
    vmap <silent> <leader>ff     <Plug>(coc-format-selected)
    nmap <silent> <leader>f    <Plug>(coc-format)
    nmap <silent> <leader>r     <Plug>(coc-rename)
    nmap <silent> <leader>re    <Plug>(coc-refactor)
    nmap <leader>c  :CocCommand <cr>
    nmap <leader>a  <Plug>(coc-codeaction)
    vmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>qf  <Plug>(coc-fix-current)
    nmap <silent> <C-h> :call CocActionAsync('showSignatureHelp') <cr>
    nmap <silent> <leader>al :call CocActionAsync('diagnosticToggle') <cr>
    nmap <silent> <leader>al :call CocActionAsync('diagnosticToggle') <cr>
    nmap <silent> <leader>sp :call CocActionAsync('toggleExtension', "coc-spell-checker") <cr>
    nmap <silent> <leader>i  :call CocAction('doHover') <cr>
    nmap <C-q>  :CocList diagnostics <CR>
    nmap <C-n>  <Plug>(coc-diagnostic-next)
    nmap <C-p>  <Plug>(coc-diagnostic-prev)
    xmap if     <Plug>(coc-funcobj-i)
    omap if     <Plug>(coc-funcobj-i)
	xmap af     <Plug>(coc-funcobj-a)
	omap af     <Plug>(coc-funcobj-a)
	xmap ic     <Plug>(coc-classobj-i)
	omap ic     <Plug>(coc-classobj-i)
    xmap ac     <Plug>(coc-classobj-a)
	omap ac     <Plug>(coc-classobj-a)

    " requires coc-fzf-preview
    map <C-G>   :CocCommand fzf-preview.GitFiles <CR>
    map <C-F>   :CocCommand fzf-preview.DirectoryFiles <CR>
    nmap <C-S>  :CocCommand fzf-preview.Ctags <CR>
    nmap ;      :CocCommand fzf-preview.Buffers<cr>
    command! -nargs=* Ag :call CocActionAsync('runCommand', 'fzf-preview.ProjectGrep', <q-args>)
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " scroll float
	if has('nvim-0.4.3') || has('patch-8.2.0750')
	  nnoremap <nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
	  nnoremap <nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
	  inoremap <nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	  inoremap <nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	endif
augroup end

" fzf-preview configuration
let g:fzf_preview_floating_window_rate = 1
let g:fzf_preview_fzf_color_option = 'fg:-1,bg:-1,hl:-1,fg+:-1,bg+:-1,hl+:-1,info:-1,marker:-1,header:-1'

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
let g:tagbar_left = 1

" ALE configurations
" noremap <leader>al :ALEToggle<CR>
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 0
let g:ale_list_window_size = 5
let g:ale_fixers = {'javascript': ['prettier'], 'python': ['black', 'autopep8'], 'c': ['clang-format'], 'cpp': ['clang-format']}
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

" nnn configurations
let g:nnn#command = 'nnn -C'
let g:nnn#action = {
      \ '<C-h>': 'split',
      \ '<C-v>': 'vsplit' }
let $DISABLE_FILE_OPEN_ON_NAV=1
let $NNN_RESTRICT_NAV_OPEN=1

" identify syntax highliting group under cursor
" see: https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
nmap <leader>hi :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" stop matching parents
function! g:FckThatMatchParen ()
    if exists(":NoMatchParen")
        :NoMatchParen
    endif
endfunction

augroup plugin_initialize
    autocmd!
    autocmd VimEnter * call FckThatMatchParen()
augroup END
