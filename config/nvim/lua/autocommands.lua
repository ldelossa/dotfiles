-- a dumb way to do this, but certain codebases should use tabs with 8 spaces
-- cilium and kernel programming.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c" },
	callback = function()
		-- if current file's full path contains cilium set tabstop=8 and shiftwidth=8
		if vim.fn.expand("%:p:h"):match("cilium") then
			vim.api.nvim_command("setlocal tabstop=8 shiftwidth=8")
			-- set comment string to /* */ format
			vim.api.nvim_command("setlocal commentstring=/*\\ %s\\ */")
		end
		if vim.fn.expand("%:p:h"):match("linux") then
			vim.api.nvim_command("setlocal tabstop=8 shiftwidth=8")
			-- set comment string to /* */ format
			vim.api.nvim_command("setlocal commentstring=/*\\ %s\\ */")
		end
	end,
})

-- lau gets a spacing indentation of 2
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua" },
	callback = function()
		vim.api.nvim_command("setlocal tabstop=2 shiftwidth=2")
		vim.api.nvim_command("setlocal tabstop=2 shiftwidth=2")
	end,
})

-- go is the only language that should format on save.
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params(0, "utf-8")
		params.context = { only = { "source.organizeImports" } }
		-- buf_request_sync defaults to a 1000ms timeout. Depending on your
		-- machine and codebase, you may want longer. Add an additional
		-- argument after params if you find that you have to write the file
		-- twice for changes to be saved.
		-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format({ async = false })
	end,
})

-- do not let auto-session create a session if the current buffer is
-- mini.starter and VIM is exiting.
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		if vim.bo.filetype ~= "starter" then
			return
		end
		vim.api.nvim_clear_autocmds({
			group = "auto_session_group",
			event = {"VimLeave"}
		})
	end
})

-- enable spell check for git commit messages
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
	end,
})
