-- status line currently depends on 
-- nvim-gps
-- nvim-web-devicons

-- statusline
vim.api.nvim_exec(
[[
func! NvimGps() abort
	return luaeval("require'nvim-gps'.is_available()") ? luaeval("require'nvim-gps'.get_location()") : ''
endf

function! Icon() abort
    return luaeval("require'nvim-web-devicons'.get_icon(vim.fn.expand('%:t'), vim.fn.expand('%:e'), {default=true})")
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#StatusLine#
set statusline+=\ %r%m%f\ >
set statusline+=\ %{NvimGps()}
set statusline+=%=
set statusline+=%#PmenuSel#
set statusline+=\ %{Icon()}
set statusline+=\ %Y
set statusline+=\ %p%%
set statusline+=\ %l:%L:%c
set statusline+=\ 
]], false)
