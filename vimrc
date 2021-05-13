inoremap <C-@> <c-x><c-o>
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
au BufRead,BufNewFile *.asm set filetype=nasm
au BufRead,BufNewFile *.cc set filetype=cpp

" vim8 term settings
nnoremap <leader>tm :topleft term<CR>
tmap <C-W>v <C-W>:vert term<CR>
tmap <C-W>s <C-W>:term<CR>

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
    Plug 'mcchrish/nnn.vim'
    Plug 'ldelossa/vimdark'
    Plug 'w0rp/ale'
    Plug 'vim-ctrlspace/vim-ctrlspace'
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

" ALE configurations
noremap <leader>al :ALEToggle<CR>
let g:ale_completion_enabled = 1
let g:ale_use_global_executables = 1
let g:ale_hover_to_preview  = 1
let g:ale_fix_on_save = 1
let g:ale_linters = {
  \ 'go': ['gopls', 'goimports'],
  \ 'python': ['pyright'],
  \ 'markdown': ['markdownlint'],
  \ 'cpp': ['clangd', 'ccls'],
  \}
let g:ale_fixers = {
  \ '*':  ['remove_trailing_lines', 'trim_whitespace'],
  \ 'go': ['goimports'],
  \ 'cpp': ['clangd', 'ccls'],
  \}
highlight ALEError ctermfg=196
highlight ALEWarning ctermfg=110
augroup ALE
    set omnifunc=ale#completion#OmniFunc
    nnoremap gd  :ALEGoToDefinition<CR>
    nnoremap gdv :ALEGoToDefinition -vsplit<CR>
    nnoremap gds :ALEGoToDefinition -split<CR>
    nnoremap <leader>r :ALERename<CR>
    nnoremap <leader>i :ALEHover<CR>
    nnoremap <leader>u :ALEFindReferences<CR>
    nnoremap <C-n> :ALENextWrap<CR>
    nnoremap <C-p> :ALEPreviousWrap<CR>
augroup END

" CtrlSpace configuration
augroup CtrlSpace
    let g:CtrlSpaceSetDefaultMapping = 0
    let g:CtrlSpaceDefaultMappingKey = ""
    nnoremap <silent><C-p> :CtrlSpace O<CR>
    nnoremap <silent> ;   :<c-u>CtrlSpace p<CR>
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

" identify syntax highliting group under cursor
" see: https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
nmap <leader>hi :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
