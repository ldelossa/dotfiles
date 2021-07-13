" nnn configurations
let g:nnn#command = 'nnn -C'
let g:nnn#action = {
      \ '<C-h>': 'split',
      \ '<C-v>': 'vsplit' }
let $DISABLE_FILE_OPEN_ON_NAV=1
let $NNN_RESTRICT_NAV_OPEN=1
nnoremap <leader>nn :NnnPicker %:p:h<CR>
nnoremap <leader>n :NnnPicker<CR>
" nnoremap <C-f> :NnnPicker -Po<CR>
