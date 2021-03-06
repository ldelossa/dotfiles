function! DarkMode()
    let $BAT_THEME="1337"
    let $FZF_DEFAULT_OPTS='--color=dark'
    colorscheme vimdark
endfunction

function! LightMode()
    let $BAT_THEME="gruvbox-light"
    let $FZF_DEFAULT_OPTS='--color=light'
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

