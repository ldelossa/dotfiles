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

-- on attach method for lsps
local on_attach = function(client, bufnr)
	vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
end

-- ripped from cmp.nvim
local default_capabilities = function(override)
	override = override or {}
	return {
		textDocument = {
			completion = {
				dynamicRegistration = true,
				completionItem = {
					snippetSupport = true,
					commitCharactersSupport = true,
					deprecatedSupport = true,
					preselectSupport = true,
					tagSupport = {
						valueSet = {
							1, -- Deprecated
						},
					},
					insertReplaceSupport = false,
					resolveSupport = {
						properties = {
							"documentation",
							"detail",
							"additionalTextEdits",
							"sortText",
							"filterText",
							"insertText",
							"textEdit",
							"insertTextFormat",
							"insertTextMode",
						},
					},
					insertTextModeSupport = {
						valueSet = {
							1, -- asIs
							2, -- adjustIndentation
						},
					},
					labelDetailsSupport = true,
				},
				contextSupport = true,
				insertTextMode = 1,
				completionList = {
					itemDefaults = {
						"commitCharacters",
						"editRange",
						"insertTextFormat",
						"insertTextMode",
						"data",
					},
				},
			},
		},
	}
end

local on_init = function(client, initialization_result)
	if client.server_capabilities then
		client.server_capabilities.semanticTokensProvider = false
	end
end

local nvim_lsp = require("lspconfig")
nvim_lsp.bashls.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,

})
nvim_lsp.lua_ls.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT'
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				}
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			}
		})
	end,
	settings = {
		Lua = {}
	}
})
nvim_lsp.dockerls.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,
})
nvim_lsp.html.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,
})
nvim_lsp.jsonls.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,

})
nvim_lsp.ts_ls.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,

})
nvim_lsp.vimls.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,

})
nvim_lsp.yamlls.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,

})
nvim_lsp.gopls.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,
	settings = {
		gopls = {
			["local"] = "github.com/cilium/cilium",
			buildFlags = {"-tags=unparallel"},
			gofumpt = false,
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
			semanticTokens = false,
			experimentalPostfixCompletions = true,
			completeFunctionCalls = true,
		},
	},
})
nvim_lsp.zls.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,

})
nvim_lsp.clangd.setup({
	capabilities = default_capabilities(),
	on_attach = on_attach,
	on_init = on_init,
	cmd = {
		"clangd",
		"--offset-encoding=utf-16",
		-- this causes a dot symbol next to completion and Neovim does not handle
		-- this well.
		"--header-insertion=never"
	},
})
