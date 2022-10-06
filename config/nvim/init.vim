" shell differences between mac and linux
if has('macunix')
    set shell=/usr/local/bin/zsh
else
    set shell=/usr/bin/zsh
endif

" clipboard differenes between mac and linux
if has('macunix')
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

" map normal clipboard keys
nnoremap <C-c> "+y
nnoremap <C-v> "+p
inoremap <C-c> "+y
inoremap <C-v> "+p

" general configurations
syntax on
filetype plugin indent on
set number
set numberwidth=1
set backspace=2 
set updatetime=275
set timeoutlen=500
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
set signcolumn=number
set termguicolors
set noequalalways
set autoread
set sidescrolloff=15
set shortmess=atosTc
set cc=80
set nowrap
set laststatus=3
set cursorline
set mouse=a
set guifont=FiraCode\ Nerd\ Font\ Mono:h13

nnoremap bd :bp\|bd #<cr>
nnoremap P "0p

" set Alt-r to allow pasting from registers in terminal mode.
lua vim.keymap.set('t', '<C-R>', [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })

" remove highlights
nnoremap <C-h> :noh <CR>

" disable auto comments on next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" reset window ratio on resize
" autocmd VimResized * exec "normal \<c-w>\<c-=>"

" don't mistype W as Window
:cabbrev W <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'w' : 'W')<CR>

" turn on code folding, defaults to all folds open
set foldmethod=syntax
set foldlevel=9999

" paste yank buffer
nnoremap <leader>py "0p

" remap write
nnoremap <leader>w :w<cr>

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

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  nnoremap \ :Ag<SPACE> 
endif

" identify syntax highliting group under cursor
" see: https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
nmap <leader>hi :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

if exists("g:neovide")
    let g:neovide_transparency=1.0
    let g:neovide_floating_opacity=1.0
    " system clipboard
    nmap <c-c> "+y
    vmap <c-c> "+y
    nmap <c-v> "+p
    inoremap <c-v> <c-r>+
    cnoremap <c-v> <c-r>+
    " use <c-r> to insert original character without triggering things like auto-pairs
    inoremap <c-r> <c-v>
endif


" source modular configs
source $HOME/.config/nvim/plugs.vim
source $HOME/.config/nvim/lua/configs/quickfix.vim
source $HOME/.config/nvim/lua/configs/copycmds.vim
