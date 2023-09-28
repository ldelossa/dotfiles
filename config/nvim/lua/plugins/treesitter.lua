return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    init = function() end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["as"] = "@class.outer",
            ["is"] = "@class.inner",
            ["am"] = "@call.outer",
            ["im"] = "@call.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["a/"] = "@comment.outer",
          },
        },

        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]s"] = "@class.outer",
            ["]a"] = "@parameter.outer",
            ["]m"] = "@call.outer",
            ["]b"] = "@block.outer",
            ["]i"] = "@conditional.outer",
            ["]l"] = "@loop.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]S"] = "@class.outer",
            ["]A"] = "@parameter.outer",
            ["]B"] = "@block.outer",
            ["]M"] = "@call.outer",
            ["]I"] = "@conditional.outer",
            ["]L"] = "@loop.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[s"] = "@class.outer",
            ["[a"] = "@parameter.outer",
            ["[m"] = "@call.outer",
            ["[b"] = "@block.outer",
            ["[i"] = "@conditional.outer",
            ["[l"] = "@loop.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[S"] = "@class.outer",
            ["[A"] = "@parameter.outer",
            ["[M"] = "@call.outer",
            ["[B"] = "@block.outer",
            ["[I"] = "@conditional.outer",
            ["[L"] = "@loop.outer",
          },
        },
      },
    },
  },
}
