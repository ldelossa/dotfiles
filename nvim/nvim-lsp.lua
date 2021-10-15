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

  -- pass client to aerial if being used
  local status, _ = pcall(require, 'aerial')
  if status then
      require('aerial').on_attach(client)
  end

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
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<C-p>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("n", "<space>o", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
  buf_set_keymap("n", "<space>i", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)

  vim.api.nvim_command('set shortmess+=c')
  vim.api.nvim_command('sign define DiagnosticSignError text=🄴  texthl=Error linehl= numhl=')
  vim.api.nvim_command('sign define DiagnosticSignWarn text=🅆  texthl=Warning linehl= numhl=')
  vim.api.nvim_command('sign define DiagnosticSignInfo text=🄸  texthl=DiagnosticSignInfo linehl= numhl=')
  vim.api.nvim_command('sign define DiagnosticSignHint text=🄷  texthl=DiagnosticSignHint linehl= numhl=')
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "dartls", "clangd", "rust_analyzer", "yamlls", "bashls", "vimls" }
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

-- nvim_lsp["ccls"].setup {
--   on_attach = on_attach, 
--   flags = {
--       debounce_text_changes = 150,
--   },
--   init_options = {
--       clang = {
--           extraArgs = { "--include-directory=/usr/lib64/clang/12/include", "--include-directory=/usr/local/lib"  };
--       };
--       cache = {
--         directory = "/home/louis/.cache/ccls"
--       };
--   },
-- }

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
}
