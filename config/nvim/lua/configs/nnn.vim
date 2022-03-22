" nnn configurations
let g:nnn#command = 'nnn -C'
let g:nnn#action = {
    \ '<leader>t': 'tab split',
    \ '<leader>s': 'split',
    \ '<leader>v': 'vsplit' }
let $DISABLE_FILE_OPEN_ON_NAV=1
let $NNN_RESTRICT_NAV_OPEN=1
" nnoremap <leader><leader> :NnnPicker %:p:h<CR>
" nnoremap <leader>n :NnnPicker<CR>
