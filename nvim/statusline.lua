-- status line currently depends on 
-- nvim-gps
-- nvim-web-devicons
-- gitsigns.nvim

-- statusline
vim.api.nvim_exec(
[[
func! NvimGps() abort
	return luaeval("require'nvim-gps'.is_available()") ? luaeval("require'nvim-gps'.get_location()") : ''
endf

function! Icon() abort
    let icon = luaeval("require'nvim-web-devicons'.get_icon(vim.fn.expand('%:t'), vim.fn.expand('%:e'))")
    if icon == v:null
        return ''
    endif
    return icon 
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  if len(l:branchname) != 0
    let l:branchname = ' ' . l:branchname
  endif
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ "\<C-V>" : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set statusline+=%#PmenuSel#
set statusline+=\ %{g:currentmode[mode()]}\ 
set statusline+=%#StatusLine#
set statusline+=\ %r%m%f\ >
set statusline+=\ %{NvimGps()}
set statusline+=%=
set statusline+=%#PmenuSel#
set statusline+=\ %{Icon()}
set statusline+=\ %Y
set statusline+=\ %p%%
set statusline+=\ %l:%L:%c
set statusline+=\ %{get(b:,'gitsigns_status','')}
set statusline+=\ %{StatuslineGit()}\ 
]], false)
