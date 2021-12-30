require('litee.lib').setup({
    tree = {
        icon_set = "codicons"
    },
    panel = {
        orientation = "left",
        panel_size  = 30
    }
})
require('litee.filetree').setup({
})
require('litee.symboltree').setup({
    icon_set = "codicons",
})
require('litee.calltree').setup({
    icon_set = "codicons",
})

local opts = { silent = true }
vim.api.nvim_set_keymap("n", "<C-t>",   ":LTPanel<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>t",  ":LTPanel<cr>", opts)

-- calltree specific commands
vim.api.nvim_set_keymap("n", "<C-h>o",     ":LTOpenToCalltree<cr>", opts)
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
vim.api.nvim_set_keymap("n", "<C-h>h",     ":LTHoverCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>d",     ":LTDetailsCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-h>x",     ":LTCloseCalltree<cr>", opts)

-- symboltree specific commands
vim.api.nvim_set_keymap("n", "<C-s>o", ":LTOpenToSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>n", ":LTNextSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>p", ":LTPrevSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>e", ":LTExpandSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>c", ":LTCollapseSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>C", ":LTCollapseAllSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>j", ":LTJumpSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>s", ":LTJumpSymboltreeSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>v", ":LTJumpSymboltreeVSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>t", ":LTJumpSymboltreeTab<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>h", ":LTHoverSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>d", ":LTDetailsSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>x", ":LTCloseSymboltree<cr>", opts)

-- filetree specific commands
vim.api.nvim_set_keymap("n", "<C-m>f", ":LTOpenFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>o", ":LTOpenToFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>n", ":LTNextFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>p", ":LTPrevFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>e", ":LTExpandFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>c", ":LTCollapseFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>C", ":LTCollapseAllFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>j", ":LTJumpFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>s", ":LTJumpFiletreeSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>v", ":LTJumpFiletreeVSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>t", ":LTJumpFiletreeTab<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>x", ":LTCloseFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>N", ":LTTouchFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>DD", ":LTRemoveFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>P", ":LTCopyFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>M", ":LTMoveFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>D", ":LTMkdirFiletree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-m>R", ":LTTRenameFiletree<cr>", opts)

vim.api.nvim_set_keymap("n", "<C-l>o", "<cmd>lua require('litee.lib.lsp.wrappers').buf_outgoing_calls()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-l>i", "<cmd>lua require('litee.lib.lsp.wrappers').buf_incoming_calls()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-l>do", "<cmd>lua require('litee.lib.lsp.wrappers').buf_document_symbol()<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-l>o", "<cmd>lua require('litee.lib.lsp.wrappers').buf_outgoing_calls()<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-l>i", "<cmd>lua require('litee.lib.lsp.wrappers').buf_incoming_calls()<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-l>do", "<cmd>lua require('litee.lib.lsp.wrappers').buf_document_symbol()<CR>", opts)
