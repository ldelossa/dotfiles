require('litee.lib').setup({
    tree = {
        icon_set = "codicons"
    },
    panel = {
        orientation = "right",
        panel_size  = 30
    },
    term = {
        position = "bottom",
        term_size = 15,
    }
})
require('litee.filetree').setup({
    hide_cursor = false,
})
require('litee.symboltree').setup({
    icon_set = "codicons",
    hide_cursor = false,
})
require('litee.calltree').setup({
    icon_set = "codicons",
    hide_cursor = false,
})
require('litee.bookmarks').setup({
    icon_set = "codicons",
})

require('litee.gh').setup({
    icon_set = "codicons",
    map_resize_keys = true,
})

local opts = { silent = true }
-- litee.lib mappings
vim.api.nvim_set_keymap("n", "<C-t>",   ":LTPanel<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>t",  ":LTPanel<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>tm", ":LTTerm<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>h",  ":LTClearJumpHL<cr>", opts)

-- calltree specific commands
vim.api.nvim_set_keymap("n", "<C-h>o",     ":LTOpenToCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>oo",    ":LTPopOutCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>n",     ":LTNextCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>p",     ":LTPrevCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>e",     ":LTExpandCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>c",     ":LTCollapseCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>C",     ":LTCollapseAllCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>f",     ":LTFocusCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>S",     ":LTSwitchCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>j",     ":LTJumpCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>s",     ":LTJumpCalltreeSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>v",     ":LTJumpCalltreeVSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>t",     ":LTJumpCalltreeTab<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>i",     ":LTHoverCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>h",     ":LTHoverCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>d",     ":LTHideCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>x",     ":LTCloseCalltree<cr>", opts)

-- symboltree specific commands
vim.api.nvim_set_keymap("n", "<C-s>o", ":LTOpenToSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>oo", ":LTPopOutSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>n", ":LTNextSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>p", ":LTPrevSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>e", ":LTExpandSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>c", ":LTCollapseSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>C", ":LTCollapseAllSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>j", ":LTJumpSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>s", ":LTJumpSymboltreeSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>v", ":LTJumpSymboltreeVSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>t", ":LTJumpSymboltreeTab<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>i", ":LTHoverSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>d", ":LTDetailsSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>h", ":LTHideSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>x", ":LTCloseSymboltree<cr>", opts)

vim.api.nvim_set_keymap("n", "<C-l>o", "<cmd>lua require('litee.lib.lsp.wrappers').buf_outgoing_calls()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-l>i", "<cmd>lua require('litee.lib.lsp.wrappers').buf_incoming_calls()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-l>S", "<cmd>lua require('litee.lib.lsp.wrappers').buf_document_symbol()<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-l>o", "<cmd>lua require('litee.lib.lsp.wrappers').buf_outgoing_calls()<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-l>i", "<cmd>lua require('litee.lib.lsp.wrappers').buf_incoming_calls()<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-l>S", "<cmd>lua require('litee.lib.lsp.wrappers').buf_document_symbol()<CR>", opts)

-- filetree specific commands
vim.api.nvim_set_keymap("n", "<leader><leader>", ":LTOpenFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>o", ":LTOpenToFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>oo", ":LTPopOutFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>n", ":LTNextFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>p", ":LTPrevFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>e", ":LTExpandFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>c", ":LTCollapseFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>C", ":LTCollapseAllFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>j", ":LTJumpFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>s", ":LTJumpFiletreeSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>v", ":LTJumpFiletreeVSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>t", ":LTJumpFiletreeTab<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>x", ":LTCloseFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>h", ":LTHideFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>N", ":LTTouchFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>DD", ":LTRemoveFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>P", ":LTCopyFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>M", ":LTMoveFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>D", ":LTMkdirFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-x>R", ":LTTRenameFiletree<cr>", opts)

-- bookmarks specific commands
vim.api.nvim_set_keymap("n", "<C-b>n", ":LTOpenNotebook<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-b>o", ":LTOpenToNotebook<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-b>oo", ":LTPopOutNotebook<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-b>l", ":LTListNotebooks<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-b>c", ":LTCreateBookmark<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-b>h", ":LTHideBookmarks<cr>", opts)

