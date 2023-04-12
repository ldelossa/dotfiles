-- Example config in Lua
require("github-theme").setup({
  -- Overwrite the highlight groups
  overrides = function(c)
    return {
      DiffChange = {fg = c.bright_blue, bg = c.bg_visual_selection},
      DiffAdd    = {fg = c.diff.add_fg, bg = c.diff.add},
      DiffText   = {fg = c.orange, bg = c.bg_visual_selection}
    }
  end
})


-- check kitty theme
local file = io.open("/home/louis/.config/kitty/current-theme.conf")
io.input(file)
local theme_line = io.read()

if theme_line == "# light" then
    vim.cmd("colorscheme github_light")
else
    vim.cmd("colorscheme github_dimmed")
end

