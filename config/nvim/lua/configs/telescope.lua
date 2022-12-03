local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

require('telescope').setup({
    defaults = {
        layout_strategy = "vertical",
        layout_config = { height = 0.95 },
        mappings = {
            n = {
                v = require('telescope.actions').file_vsplit,
                s = require('telescope.actions').file_split,
                t = require('telescope.actions').file_tab,
                ["<C-c>"] = require('telescope.actions').close,
            },
        }
    },
    extensions = {
        ["ui-select"] = {
            themes.get_dropdown {
                -- even more opts
            }

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
            --   codeactions = false,
            -- }
        }
    }
})

-- use ui-select
require("telescope").load_extension("ui-select")


local opts = { silent = true }

vim.keymap.set('n', '<C-f>', ':Telescope<CR>', opts)

vim.keymap.set('n', '\'', function() builtin.buffers({ sort_lastused = true, ignore_current_buffer = true }) end, opts)
vim.keymap.set('n', '<leader>c', function() builtin.commands(themes.get_dropdown()) end, {})
vim.keymap.set('n', '<leader>', builtin.find_files, {})
vim.keymap.set('n', '<leader>h', builtin.oldfiles, {})
vim.keymap.set('n', '<C-h>', builtin.command_history, {})

-- git stuff
vim.keymap.set('n', '<C-g>ss', builtin.git_status, {})
