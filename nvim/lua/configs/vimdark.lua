 vim.cmd [[
 function! DarkMode()
     let $BAT_THEME="1337"
     let $FZF_DEFAULT_OPTS='--keep-right --color="dark" --color="header:75,info:75" --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up'
     colorscheme nordfox
     " needs to source in-order to set fzf-lua fzf theme again.
     source ~/.config/nvim/lua/configs/fzf.lua
 endfunction
 ]]

vim.cmd [[ 
function! LightMode()
     let $BAT_THEME="gruvbox-light"
     let $FZF_DEFAULT_OPTS='--keep-right --color="light" --color="header:25,info:25" --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up'
     colorscheme dayfox
     source ~/.config/nvim/lua/configs/fzf.lua
endfunction
]]

local opts = {silent=true, noremap=true}
vim.api.nvim_set_keymap('n', '<leader>lm', ':call LightMode()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>dm', ':call DarkMode()<cr>', opts)

-- check kitty theme
local file = io.open("/home/louis/.config/kitty/current-theme.conf")
io.input(file)
local theme_line = io.read()

if theme_line == "# light" then
    vim.fn.LightMode()
else
    vim.fn.DarkMode()
end
