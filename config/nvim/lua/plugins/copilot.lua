
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
          accept = "<C-]>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-[>",
        },
      },
    },
  },
}
