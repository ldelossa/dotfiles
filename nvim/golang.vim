lua <<EOF
  -- …
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
EOF

autocmd BufWritePre *.go lua goimports(1000)
autocmd BufWritePre *.go silent lua vim.lsp.buf.formatting()
