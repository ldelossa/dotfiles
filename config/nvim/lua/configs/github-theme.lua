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


