return {
  {
    "folke/noice.nvim",
    opts = {
      views = {
        cmdline_popup = {
          position = {
            row = "100%",
            col = "50%",
          },
          border = {
            style = "none",
            padding = { 2, 3 },
          },
          filter_options = {},
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      },
    },
  },
}
