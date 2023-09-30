
return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      panel = { enabled = true },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = false, -- <Tab> but set in nvim-cmp settings
          accept_word = false,
          accept_line = false,
          next = "<C-j>",
          prev = false,
          dismiss = "<C-[>",
        },
      },
    },
  },
}
