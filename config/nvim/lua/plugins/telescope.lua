return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      layout_strategy = "vertical",
      layout_config = { height = 0.95 },
      mappings = {
        n = {
          v = require("telescope.actions").file_vsplit,
          s = require("telescope.actions").file_split,
          t = require("telescope.actions").file_tab,
          ["<C-c>"] = require("telescope.actions").close,
        },
      },
    },
  },
}
