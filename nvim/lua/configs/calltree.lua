require('calltree').setup({
    icons = "codicons",
    layout = "left",
    resolve_symbols = true,
    indent_guides = true,
    unified_panel = false,
    scrolloff = true,
    hide_cursor = true,
})

local opts = { silent = true }
vim.api.nvim_set_keymap("n", "<C-t>",   ":CTPanel<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>t",  ":CTPanel<cr>", opts)

-- calltree specific commands
vim.api.nvim_set_keymap("n", "<C-t>o",     ":CTOpenToCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>n",     ":CTNextCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>p",     ":CTPrevCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>e",     ":CTExpandCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>c",     ":CTCollapseCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>C",     ":CTCollapseAllCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>f",     ":CTFocusCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>S",     ":CTSwitchCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t><CR>",  ":CTJumpCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>s",     ":CTJumpCalltreeSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>v",     ":CTJumpCalltreeVSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>t",     ":CTJumpCalltreeTab<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>h",     ":CTHoverCalltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-t>d",     ":CTDetailsCalltree<cr>", opts)

vim.api.nvim_set_keymap("i", "<C-t>o",     ":CTOpenToCalltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>n",     ":CTNextCalltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>p",     ":CTPrevCalltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>e",     ":CTExpandCalltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>c",     ":CTCollapseCalltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>C",     ":CTCollapseAllCalltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>f",     ":CTFocusCalltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>S",     ":CTSwitchCalltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t><CR>",  ":CTJumpCalltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>s",     ":CTJumpCalltreeSplit<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>v",     ":CTJumpCalltreeVSplit<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>t",     ":CTJumpCalltreeTab<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>h",     ":CTHoverCalltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-t>d",     ":CTDetailsCalltree<cr>", opts)

-- symboltree specific commands
vim.api.nvim_set_keymap("n", "<C-s>o", ":CTOpenToSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>n", ":CTNextSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>p", ":CTPrevSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>e", ":CTExpandSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>c", ":CTCollapseSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>C", ":CTCollapseAllSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s><CR>", ":CTJumpSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>s", ":CTJumpSymboltreeSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>v", ":CTJumpSymboltreeVSplit<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>t", ":CTJumpSymboltreeTab<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>h", ":CTHoverSymboltree<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-s>d", ":CTDetailSymboltree<cr>", opts)

vim.api.nvim_set_keymap("i", "<C-s>o", ":CTOpenToSymboltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>n", ":CTNextSymboltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>p", ":CTPrevSymboltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>e", ":CTExpandSymboltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>c", ":CTCollapseSymboltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>C", ":CTCollapseAllSymboltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s><CR>", ":CTJumpSymboltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>s", ":CTJumpSymboltreeSplit<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>v", ":CTJumpSymboltreeVSplit<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>t", ":CTJumpSymboltreeTab<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>h", ":CTHoverSymboltree<cr>", opts)
vim.api.nvim_set_keymap("i", "<C-s>d", ":CTDetailSymboltree<cr>", opts)

vim.api.nvim_set_keymap("n", "<C-l>o", "<cmd>lua require('calltree.lsp.wrappers').buf_outgoing_calls()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-l>i", "<cmd>lua require('calltree.lsp.wrappers').buf_incoming_calls()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-l>do", "<cmd>lua require('calltree.lsp.wrappers').buf_document_symbol()<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-l>o", "<cmd>lua require('calltree.lsp.wrappers').buf_outgoing_calls()<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-l>i", "<cmd>lua require('calltree.lsp.wrappers').buf_incoming_calls()<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-l>do", "<cmd>lua require('calltree.lsp.wrappers').buf_document_symbol()<CR>", opts)
