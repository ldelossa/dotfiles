-- use omnifunc
vim.api.nvim_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
vim.o.completeopt = "menuone,noselect"
vim.api.nvim_command('inoremap <C-space> <C-x><C-o>')

local nvim_lsp = require('lspconfig')

-- disable virtual text for all diagnostic handlers.
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline    = false,
        virtual_text = false,
    }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help, {
                border = 'single',
                close_events = {"CursorMoved", "BufHidden", "InsertCharPre"},
    }
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { silent=true }

  -- only define these mappings if fzf-lua is not being used
  local status, _ = pcall(require, 'fzf-lua')
  if not status then
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>u', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  end

  buf_set_keymap('n', '<leader>i', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap("n", "<leader>l", "<cmd>lua vim.lsp.codelens.run()<CR>", {silent = true;})
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
  buf_set_keymap('n', '<C-p>', '<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>', opts)
  buf_set_keymap('n', '<C-n>', '<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("n", "<space>o", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
  buf_set_keymap("n", "<space>co", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
  buf_set_keymap("n", "<space>ci", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)

  vim.api.nvim_command('set shortmess+=c')
  vim.api.nvim_command('sign define DiagnosticSignError text=🄴  texthl=Error linehl= numhl=')
  vim.api.nvim_command('sign define DiagnosticSignWarn text=🅆  texthl=Warning linehl= numhl=')
  vim.api.nvim_command('sign define DiagnosticSignInfo text=🄸  texthl=Warning linehl= numhl=')
  vim.api.nvim_command('sign define DiagnosticSignHint text=🄷  texthl=Warning linehl= numhl=')
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "dartls", "clangd", "rust_analyzer", "yamlls", "bashls", "vimls", "terraformls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
      on_attach = on_attach,
      flags = {
          debounce_text_changes = 150,
      },
  }
end

-- this is necessary since vim ships with its own c omnifunc and applies it
-- it on FileType c
vim.api.nvim_command('autocmd FileType c set omnifunc=v:lua.vim.lsp.omnifunc')
vim.api.nvim_command('autocmd FileType cpp set omnifunc=v:lua.vim.lsp.omnifunc')

nvim_lsp["gopls"].setup {
  on_attach = on_attach,
  filetypes = {"go", "gomod"},
  cmd = {
    "gopls", -- share the gopls instance if there is one already
    "-remote.debug=:0"
  },
  flags = {allow_incremental_sync = true, debounce_text_changes = 150},
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
       usePlaceholders = true,
       completeUnimported = true,
       staticcheck = true,
       matcher = "fuzzy",
       diagnosticsDelay = "500ms",
       experimentalWatchedFileDelay = "100ms",
       symbolMatcher = "fuzzy"
     },
   },

nvim_lsp["sumneko_lua"].setup {
    on_attach = on_attach,
    cmd = {"/home/louis/git/cpp/lua-language-server/bin/Linux/lua-language-server"},
    filetypes = { "lua" },
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
}
