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

