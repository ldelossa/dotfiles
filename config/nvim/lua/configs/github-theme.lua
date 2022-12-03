-- Example config in Lua
require("github-theme").setup({
  -- Overwrite the highlight groups
  overrides = function(c)
    return {
      DiffChange = {fg = c.bright_blue, bg = c.bg_visual_selection},
      -- DiffAdd    = {fg = c.bright_green, bg = c.diff.add},

    }
  end
})
