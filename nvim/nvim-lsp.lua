-- use omnifunc
vim.api.nvim_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
vim.o.completeopt = "menuone,noselect"

local nvim_lsp = require('lspconfig')
local nvim_command = vim.api.nvim_command


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
    }
)

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>i', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap("n", "<leader>l", "<cmd>lua vim.lsp.codelens.run()<CR>", {silent = true;})
  buf_set_keymap('n', '<leader>u', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<C-p>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("n", "<space>o", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "rust_analyzer", "yamlls", "bashls", "vimls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { 
      on_attach = on_attach, 
      flags = {
          debounce_text_changes = 150,
      },
  }
end

nvim_lsp["ccls"].setup {
  on_attach = on_attach, 
  flags = {
      debounce_text_changes = 150,
  },
  init_options = {
      clang = {
          extraArgs = { "--include-directory=/usr/lib64/clang/12/include" };
      };
      cache = {
        directory = "/home/louis/.cache/ccls"
      };
  },
}

nvim_lsp["gopls"].setup {
  on_attach = on_attach, 
  flags = {
      debounce_text_changes = 150,
  },
  settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        codelenses = {
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
          generate = true,
          gc_details = true,
       },
     },
   },
}

vim.api.nvim_command('set shortmess+=c')
vim.api.nvim_command('inoremap <C-space> <C-x><C-o>')
vim.api.nvim_command('autocmd BufEnter,CursorHold,InsertLeave * lua vim.lsp.codelens.refresh()')
vim.api.nvim_command('sign define LspDiagnosticsSignError text=🄴  texthl=Error linehl= numhl=')
vim.api.nvim_command('sign define LspDiagnosticsSignWarning text=🅆  texthl=Warning linehl= numhl=')
vim.api.nvim_command('sign define LspDiagnosticsSignInformation text=🄸  texthl=LspDiagnosticsSignInformation linehl= numhl=')
vim.api.nvim_command('sign define LspDiagnosticsSignHint text=🄷  texthl=LspDiagnosticsSignHint linehl= numhl=')

-- golang specific nvim-lsp
function goimports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports", "textDocument/Formatting"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

vim.api.nvim_command('autocmd BufWritePre *.go lua goimports(1000)')
vim.api.nvim_command('autocmd BufWritePre *.go silent lua vim.lsp.buf.formatting()')
