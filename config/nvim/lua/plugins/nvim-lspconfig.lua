local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})

-- disable virtual text for all diagnostic handlers.
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  float = { border = "rounded" },
})

local on_attach = function(client, bufnr)
  if client.name == "clangd" then
    -- remove semanitic tokens, makes reading C code with ifdefs hard.
    client.server_capabilities.semanticTokensProvider = nil
  end
end

vim.g.autoformat = false

return {
  "neovim/nvim-lspconfig",
  keys = {},
  opts = {
    diagnostics = {
      virtual_text = {},
    },
    servers = {

      tsserver = {},
      eslint = {},
      pyright = {},
      dartls = {},
      clangd = {
        on_attach = on_attach,
      },
      rust_analyzer = {},
      yamlls = {},
      bashls = {},
      vimls = {},
      jsonls = {},
      cssls = {},
      zls = {},

      gopls = {
        settings = {
          gopls = {
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          },
        },
      },
    },
    setup = {
      clangd = function(_, opts)
        opts.capabilities.offsetEncoding = { "utf-16" }
      end,
    },
  },
}
