vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		linehl = {},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "LspDiagnosticsDefaultError",
			[vim.diagnostic.severity.WARN] = "LspDiagnosticsDefaultWarning",
			[vim.diagnostic.severity.INFO] = "LspDiagnosticsDefaultInformation",
			[vim.diagnostic.severity.HINT] = "LspDiagnosticsDefaultHint",
		},
	},
})

vim.g.autoformat = false

-- disable virtual text for all diagnostic handlers.
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	virtual_text = false,
})

local on_init = function(client, initialization_result)
	if client.server_capabilities then
		client.server_capabilities.semanticTokensProvider = false
	end
end

local nvim_lsp = require("lspconfig")
nvim_lsp.dockerls.setup({})
nvim_lsp.html.setup({})
nvim_lsp.jsonls.setup({})
nvim_lsp.tsserver.setup({})
nvim_lsp.vimls.setup({})
nvim_lsp.yamlls.setup({})
nvim_lsp.gopls.setup({})
nvim_lsp.zls.setup({})
nvim_lsp.clangd.setup({
	on_init = on_init,
	cmd = {
		"clangd",
		"--offset-encoding=utf-16",
	},
})
