-- mini.pick picker that renders LSP document symbols as an outline. Each
-- row's text is `indent + [Kind] + dotted_path`, where dotted_path includes
-- every ancestor name. Putting the prefix into the item's `text` keeps
-- mini.pick's default fuzzy match and match-highlight extmarks aligned with
-- what's displayed; the leading whitespace and brackets are inert for
-- alphanumeric queries. Searching for a parent name (e.g. `MyStruct`)
-- surfaces every member because their text contains `MyStruct.<child>`.

local M = {}

local NS = vim.api.nvim_create_namespace('mini-pick-lsp-outline')

-- Full LSP SymbolKind names, unpadded.
local KIND_LABEL = {
	[1]  = 'File',
	[2]  = 'Module',
	[3]  = 'Namespace',
	[4]  = 'Package',
	[5]  = 'Class',
	[6]  = 'Method',
	[7]  = 'Property',
	[8]  = 'Field',
	[9]  = 'Constructor',
	[10] = 'Enum',
	[11] = 'Interface',
	[12] = 'Function',
	[13] = 'Variable',
	[14] = 'Constant',
	[15] = 'String',
	[16] = 'Number',
	[17] = 'Boolean',
	[18] = 'Array',
	[19] = 'Object',
	[20] = 'Key',
	[21] = 'Null',
	[22] = 'EnumMember',
	[23] = 'Struct',
	[24] = 'Event',
	[25] = 'Operator',
	[26] = 'TypeParameter',
}

local KIND_HL = {
	[1]  = 'Comment',     -- File
	[2]  = 'Include',     -- Module
	[3]  = 'Include',     -- Namespace
	[4]  = 'Include',     -- Package
	[5]  = 'Type',        -- Class
	[6]  = 'Function',    -- Method
	[7]  = 'Identifier',  -- Property
	[8]  = 'Identifier',  -- Field
	[9]  = 'Function',    -- Constructor
	[10] = 'Type',        -- Enum
	[11] = 'Type',        -- Interface
	[12] = 'Function',    -- Function
	[13] = 'Constant',    -- Variable
	[14] = 'Constant',    -- Constant
	[15] = 'String',      -- String
	[16] = 'Number',      -- Number
	[17] = 'Boolean',     -- Boolean
	[18] = 'Constant',    -- Array
	[19] = 'Constant',    -- Object
	[20] = 'Identifier',  -- Key
	[21] = 'Constant',    -- Null
	[22] = 'Constant',    -- EnumMember
	[23] = 'Type',        -- Struct
	[24] = 'Identifier',  -- Event
	[25] = 'Operator',    -- Operator
	[26] = 'Type',        -- TypeParameter
}

local function kind_label(kind)
	return KIND_LABEL[kind] or '?'
end

local function build_text(depth, kind, name_path)
	return string.rep('  ', depth) .. '[' .. kind_label(kind) .. '] ' .. name_path
end

-- DocumentSymbol has `range` and may have `children`; SymbolInformation has
-- `location.range` and may have `containerName`. Detect by presence of
-- `location`.
local function is_symbol_information(sym)
	return sym.location ~= nil
end

local function walk_document_symbols(syms, parent_path, depth, acc, path)
	for _, sym in ipairs(syms or {}) do
		local name_path = parent_path == '' and sym.name or (parent_path .. '.' .. sym.name)
		local sel = sym.selectionRange or sym.range
		local start = sel and sel.start or { line = 0, character = 0 }
		acc[#acc + 1] = {
			text  = build_text(depth, sym.kind, name_path),
			kind  = sym.kind,
			depth = depth,
			path  = path,
			lnum  = start.line + 1,
			col   = start.character + 1,
		}
		if sym.children and #sym.children > 0 then
			walk_document_symbols(sym.children, name_path, depth + 1, acc, path)
		end
	end
end

local function flatten_symbol_information(syms, acc, path)
	for _, sym in ipairs(syms or {}) do
		local container = sym.containerName or ''
		local name_path = container == '' and sym.name or (container .. '.' .. sym.name)
		local depth = container == '' and 0 or 1
		local loc = sym.location or {}
		local rng = loc.range or {}
		local start = rng.start or { line = 0, character = 0 }
		acc[#acc + 1] = {
			text  = build_text(depth, sym.kind, name_path),
			kind  = sym.kind,
			depth = depth,
			path  = path,
			lnum  = start.line + 1,
			col   = start.character + 1,
		}
	end
end

local function build_items(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/documentSymbol' })
	if #clients == 0 then
		return nil, 'no attached LSP client supports textDocument/documentSymbol'
	end

	local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
	local results, err = vim.lsp.buf_request_sync(bufnr, 'textDocument/documentSymbol', params, 2000)
	if err then return nil, err end
	if not results then return nil, 'documentSymbol request timed out' end

	local path = vim.api.nvim_buf_get_name(bufnr)
	local items = {}
	for _, res in pairs(results) do
		local syms = res.result
		if syms and #syms > 0 then
			if is_symbol_information(syms[1]) then
				flatten_symbol_information(syms, items, path)
			else
				walk_document_symbols(syms, '', 0, items, path)
			end
		end
	end
	return items
end

local function show(buf_id, items, query)
	require('mini.pick').default_show(buf_id, items, query, { show_icons = false })
	vim.api.nvim_buf_clear_namespace(buf_id, NS, 0, -1)
	for i, it in ipairs(items) do
		local lnum = i - 1
		local indent = it.depth * 2
		local hl = KIND_HL[it.kind] or 'Comment'
		local end_col = indent + #kind_label(it.kind) + 2
		pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, indent,
			{ end_row = lnum, end_col = end_col, hl_group = hl, priority = 210 })
	end
end

local function preview(buf_id, item)
	if item == nil then return end
	require('mini.pick').default_preview(buf_id, { path = item.path, lnum = item.lnum, col = item.col })
end

-- Jump in the window the picker was launched from. mini.pick records that
-- window as `MiniPick.get_picker_state().windows.target` (see pick.lua), but
-- using vim.api.nvim_get_current_win() right after `stop()` is equivalent
-- because mini.pick restores focus to the original window first.
local function choose(item)
	if item == nil then return end
	local lnum, col = item.lnum, item.col - 1
	vim.schedule(function()
		pcall(vim.api.nvim_win_set_cursor, 0, { lnum, col })
		vim.cmd('normal! zz')
	end)
end

M.lsp_outline = function(local_opts, opts)
	local pick = require('mini.pick')
	local bufnr = vim.api.nvim_get_current_buf()

	local items, err = build_items(bufnr)
	if not items then
		vim.notify('lsp_outline: ' .. err, vim.log.levels.WARN)
		return
	end
	if #items == 0 then
		vim.notify('lsp_outline: no symbols returned', vim.log.levels.INFO)
		return
	end

	local fname = vim.api.nvim_buf_get_name(bufnr):match('([^/]+)$') or '[No Name]'
	local name = string.format('LSP outline (%s)', fname)

	-- Follow-mode: as the picker selection moves, keep the source window's
	-- cursor in sync with the highlighted symbol. mini.pick blocks on
	-- `getcharstr` while running, which suppresses CursorMoved autocmds, so
	-- we drive the jump from inside custom move mappings that replace the
	-- built-in `move_down`/`move_up` actions. On cancel (no choose), restore
	-- the original cursor; on choose, the wrapper sets a flag so we leave
	-- the jumped position in place.
	local target_win = vim.api.nvim_get_current_win()
	local orig_pos = vim.api.nvim_win_get_cursor(target_win)
	local chosen = false

	-- Stamp the ' mark on the source position before follow-mode starts
	-- moving the cursor, so post-selection `''` returns here rather than to
	-- whatever symbol the user last navigated past.
	vim.cmd("normal! m'")

	local function jump_to_current()
		local m = pick.get_picker_matches()
		local it = m and m.current
		if not (it and it.lnum and vim.api.nvim_win_is_valid(target_win)) then return end
		pcall(vim.api.nvim_win_set_cursor, target_win, { it.lnum, it.col - 1 })
		vim.api.nvim_win_call(target_win, function() vim.cmd('normal! zz') end)
	end

	-- Advance current selection by `delta` (wrapping) then jump source.
	-- mini.pick has no public "step current_ind" helper, but
	-- `set_picker_match_inds(_, 'current')` accepts an absolute item index,
	-- and `get_picker_matches()` exposes `all_inds` (array of absolute
	-- indices currently matching) plus `current_ind` (the active absolute
	-- index), so we locate the position in `all_inds` and step it.
	local function move_by(delta)
		local m = pick.get_picker_matches()
		if not (m and m.all_inds) then return end
		local n = #m.all_inds
		if n == 0 then return end
		local pos = 1
		for i, abs in ipairs(m.all_inds) do
			if abs == m.current_ind then pos = i; break end
		end
		local new_pos = ((pos - 1 + delta) % n) + 1
		pick.set_picker_match_inds({ m.all_inds[new_pos] }, 'current')
		jump_to_current()
	end

	local function choose_wrap(item)
		chosen = true
		return choose(item)
	end

	local group = vim.api.nvim_create_augroup('LspOutlinePickFollow', { clear = true })
	vim.api.nvim_create_autocmd('User', {
		group = group, pattern = 'MiniPickStop', once = true,
		callback = function()
			pcall(vim.api.nvim_clear_autocmds, { group = group })
			if not chosen and vim.api.nvim_win_is_valid(target_win) then
				pcall(vim.api.nvim_win_set_cursor, target_win, orig_pos)
			end
		end,
	})

	return pick.start(vim.tbl_deep_extend('force', {
		source = {
			items   = items,
			name    = name,
			show    = show,
			preview = preview,
			choose  = choose_wrap,
		},
		-- Built-in `move_down`/`move_up`/`move_start` only accept string keys,
		-- so we disable their bindings with `''` and register our own custom
		-- actions on the same chars. Disabling is required because otherwise
		-- the built-in mapping for `<C-n>` would conflict with our custom
		-- `follow_down` on `<C-n>` (mini.pick warns and one is dropped).
		mappings = {
			move_down  = '',
			move_up    = '',
			follow_down       = { char = '<C-n>',  func = function() move_by(1)  end },
			follow_up         = { char = '<C-p>',  func = function() move_by(-1) end },
			follow_down_arrow = { char = '<Down>', func = function() move_by(1)  end },
			follow_up_arrow   = { char = '<Up>',   func = function() move_by(-1) end },
		},
	}, opts or {}))
end

function M.register()
	require('mini.pick').registry.lsp_outline = M.lsp_outline
end

return M
