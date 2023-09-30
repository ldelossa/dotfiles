function Light_theme()
  vim.cmd("colorscheme github_light")
end

function Dark_theme()
  vim.cmd("colorscheme github_dark")
end

return {
  "projekt0n/github-nvim-theme",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require("github-theme").setup({
      -- Overwrite the highlight groups
      -- overrides = function(c)
      --   return {
      --     DiffChange = { fg = c.bright_blue, bg = c.bg_visual_selection },
      --     DiffAdd = { fg = c.diff.add_fg, bg = c.diff.add },
      --     DiffText = { fg = c.orange, bg = c.bg_visual_selection },
      --   }
      -- end,
    })

    local file = io.open("/home/louis/.config/kitty/current-theme.conf")
    io.input(file)
    local theme_line = io.read()

    if theme_line == "# light" then
      vim.cmd("colorscheme github_light")
    else
      vim.cmd("colorscheme github_dark")
    end
  end,
}
