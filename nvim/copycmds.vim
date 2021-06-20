" copy buffer path commands
command! CopyDir let @+ = expand('%:p:h')
command! CopyPath let @+ = expand('%:p')
command! CopyPathLine let @+ = expand('%:p') . ":" . line(".")
nnoremap <leader>cp :let @+ = expand('%:p') . ":" . line(".")<CR>
command! CopyRel let @+ = expand('%')
