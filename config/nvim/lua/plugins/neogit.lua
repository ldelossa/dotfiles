vim.g.lazygit_use_custom_config_file_path = 1 -- config file path is evaluated if this value is 1
vim.g.lazygit_config_file_path = '~/.config/lazygit/config.yml' -- custom config file path

return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>gn"] = { name = "+Neogit" },
      },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = true,
    keys = {
      { "<leader>gnn", "<cmd>Neogit kind=auto<cr>", desc = "Open Neogit" },
      { "<leader>gnt", "<cmd>Neogit<cr>",               desc = "Open Neogit (Tab)" },
      { "<leader>gnv", "<cmd>Neogit kind=vsplit<cr>",   desc = "Open Neogit (VSplit)" },
      { "<leader>gns", "<cmd>Neogit kind=split<cr>",    desc = "Open Neogit (Split)" },
    },
  },
}
