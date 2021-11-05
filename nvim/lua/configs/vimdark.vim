 function! DarkMode()
     let $BAT_THEME="1337"
     let $FZF_DEFAULT_OPTS='--keep-right --color="dark" --color="header:75,info:75" --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up'
     colorscheme vimdark
     " needs to source in-order to set fzf-lua fzf theme again.
     source ~/.config/nvim/lua/configs/fzf.lua
 endfunction
 
 function! LightMode()
     let $BAT_THEME="gruvbox-light"
     let $FZF_DEFAULT_OPTS='--keep-right --color="light" --color="header:25,info:25" --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up'
     colorscheme vimlight
     source ~/.config/nvim/lua/configs/fzf.lua
 endfunction
 
if $TILIX_PROFILE == "light"
    call LightMode()
else
    call DarkMode()
endif

nnoremap <leader>lm :call LightMode() <CR>
nnoremap <leader>dm :call DarkMode() <CR>
