local nvim_lsp = require('lspconfig')

vim.diagnostic.config {
    float = { border = "rounded" },
}

-- disable virtual text for all diagnostic handlers.
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline    = false,
        virtual_text = false,
        float = { border = "rounded" },
    }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help, {
                border = 'rounded',
                close_events = {"BufHidden", "InsertLeave"},
    }
)

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover, {
                border = 'rounded',
    }
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- -- use omnifunc
    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- vim.o.completeopt = "menuone,noselect"
    -- vim.api.nvim_command('inoremap <C-space> <C-x><C-o>')

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Mappings.
    local opts = { silent=true }

    -- nvim-navic setup
    if pcall(require, "nvim-navic") then
        require('nvim-navic').attach(client, bufnr)
    end

    -- only define these mappings if fzf-lua is not being used
    local status, _ = pcall(require, 'fzf-lua')
    if not status then
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'gdd', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', '<leader>u', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        -- c-l namespaced
        buf_set_keymap('n', '<C-l>D', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', '<C-l>d', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', '<C-l>dd', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<C-l>ii', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-l>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', '<C-l>u', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<C-l>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

        buf_set_keymap('i', '<C-l>D', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('i', '<C-l>d', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('i', '<C-l>dd', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('i', '<C-l>ii', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('i', '<C-l>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('i', '<C-l>u', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('i', '<C-l>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    end

    buf_set_keymap('n', '<leader>i', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap("n", "<leader>l", "<cmd>lua vim.lsp.codelens.run()<CR>", {silent = true;})
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
    buf_set_keymap('n', '<C-p>', '<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>', opts)
    buf_set_keymap('n', '<C-n>', '<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>', opts)
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
    buf_set_keymap("n", "<leader>co", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
    buf_set_keymap("n", "<leader>ci", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)

    -- c-l namespaced
    buf_set_keymap('n', '<C-l>h', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-l>f', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<C-l>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap("n", "<C-l>l", "<cmd>lua vim.lsp.codelens.run()<CR>", {silent = true;})
    buf_set_keymap('n', '<C-l>e', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
    buf_set_keymap('n', '<C-l>p', '<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>', opts)
    buf_set_keymap('n', '<C-l>n', '<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>', opts)
    buf_set_keymap("n", "<C-l>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    -- buf_set_keymap("n", "<C-l>o", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
    -- buf_set_keymap("n", "<C-l>i", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
    -- buf_set_keymap("n", "<C-l>do", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)

    buf_set_keymap('i', '<C-l>h', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('i', '<C-l>s', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('i', '<C-l>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap("i", "<C-l>l", "<cmd>lua vim.lsp.codelens.run()<CR>", {silent = true;})
    buf_set_keymap('i', '<C-l>e', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
    buf_set_keymap('i', '<C-l>p', '<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>', opts)
    buf_set_keymap('i', '<C-l>n', '<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>', opts)
    buf_set_keymap("i", "<C-l>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    -- buf_set_keymap("i", "<C-l>o", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
    -- buf_set_keymap("i", "<C-l>i", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
    -- buf_set_keymap("i", "<C-l>do", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)

    vim.api.nvim_command('sign define DiagnosticSignError text=🄴  texthl=Error linehl= numhl=')
    vim.api.nvim_command('sign define DiagnosticSignWarn text=🅆  texthl=Warning linehl= numhl=')
    vim.api.nvim_command('sign define DiagnosticSignInfo text=🄸  texthl=Warning linehl= numhl=')
    vim.api.nvim_command('sign define DiagnosticSignHint text=🄷  texthl=Warning linehl= numhl=')
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
    "tsserver",
    "eslint",
    "pyright",
    "dartls",
    "clangd",
    "rust_analyzer",
    "yamlls",
    "bashls",
    "vimls",
    "terraformls",
    "jsonls",
    "cssls"
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
          debounce_text_changes = 150,
      },
  }
end

nvim_lsp["gopls"].setup {
  on_attach = on_attach,
  filetypes = {"go", "gomod"},
  cmd = {
    "gopls", -- share the gopls instance if there is one already
    "-remote.debug=:0"
  },
  flags = {allow_incremental_sync = true, debounce_text_changes = 150},
  capabilities = capabilities,
  settings = {
      gopls = {
        analyses = {unusedparams = true, unreachable = false},
        experimentalPostfixCompletions = true,
        codelenses = {
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
          generate = true,
          gc_details = true
       },
       usePlaceholders = false,
       completeUnimported = true,
       staticcheck = true,
       matcher = "fuzzy",
       diagnosticsDelay = "500ms",
       experimentalWatchedFileDelay = "100ms",
       symbolMatcher = "fuzzy",
       experimentalUseInvalidMetadata = true,
       semanticTokens = true
    },
   },
}

nvim_lsp["sumneko_lua"].setup {
   on_attach = on_attach,
   cmd = {"/home/louis/git/lua/lua-language-server/bin/lua-language-server"},
   filetypes = { "lua" },
   capabilities = capabilities,
   settings = {
       Lua = {
         runtime = {
           -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
           version = 'LuaJIT',
           -- Setup your lua path
           path = runtime_path,
         },
         diagnostics = {
           -- Get the language server to recognize the `vim` global
           globals = {'vim'},
         },
         workspace = {
           -- Make the server aware of Neovim runtime files
           library = vim.api.nvim_get_runtime_file("", true),
         },
         -- Do not send telemetry data containing a randomized but unique identifier
         telemetry = {
           enable = false,
         },
       },
   },
}

