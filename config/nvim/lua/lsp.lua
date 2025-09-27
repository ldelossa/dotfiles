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

vim.diagnostic.config({
	underline = true,
	virtual_text = false
})

local config = vim.lsp.config
local enable = vim.lsp.enable

-- enable LSPs which just use the default configuration...
enable('bashls')
enable('dockerls')
enable('html')
enable('jsonls')
enable('ts_ls')
enable('vimls')
enable('yamlls')
enable('zls')
enable('asm_lsp')
enable('pylsp')
enable('rust_analyzer')

-- now LSPs that require a divergent configuration.
config('gopls', {
	settings = {
		gopls = {
			["local"] = "github.com/cilium/cilium",
			buildFlags = { "-tags=unparallel" },
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
enable('gopls')

config('lua_ls', {
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
enable('lua_ls')

config('clangd', {
	on_init = function(client)
		if client.server_capabilities then
			client.server_capabilities.semanticTokensProvider = false
		end
	end,
	cmd = {
		"clangd",
		"--offset-encoding=utf-16",
		-- this causes a dot symbol next to completion and Neovim does not handle
		-- this well.
		"--header-insertion=never"
	},
})
enable('clangd')
