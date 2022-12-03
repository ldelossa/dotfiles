 vim.cmd [[
 function! DarkMode()
     colorscheme github_dimmed
 endfunction
 ]]

vim.cmd [[ 
function! LightMode()
     colorscheme github_light
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
