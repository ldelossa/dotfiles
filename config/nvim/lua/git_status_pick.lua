-- mini.pick picker for `git status`. Each file's staged change and
-- working-tree change appear as separate rows so a row maps to one diff and
-- one action. Sections: [S] staged, [W] working, [?] untracked, [!] unmerged.

local M = {}

local SIDE_HL = {
	S = 'DiagnosticOk',
	W = 'DiagnosticWarn',
	['?'] = 'Comment',
	['!'] = 'DiagnosticError',
}

local STATUS_HL = {
	M = 'DiagnosticWarn',
	A = 'DiagnosticOk',
	D = 'DiagnosticError',
	R = 'DiagnosticInfo',
	C = 'DiagnosticInfo',
	T = 'DiagnosticHint',
	U = 'DiagnosticError',
	['?'] = 'Comment',
}

-- Conflict combinations from git-status(1).
local UNMERGED = {
	DD = true, AU = true, UD = true, UA = true,
	DU = true, AA = true, UU = true,
}

local SECTION_ORDER = { S = 1, W = 2, ['?'] = 3, ['!'] = 4 }

local NS = vim.api.nvim_create_namespace('mini-pick-git-status')

local function repo_dir()
	local r = vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait()
	if r.code ~= 0 then return nil end
	local top = (r.stdout or ''):gsub('%s+$', '')
	if top == '' then return nil end
	return top
end

-- Parse `git status --porcelain -z` output. Each record is `XY <path>\0`;
-- renames and copies append a second NUL-terminated old path.
local function parse_porcelain(raw)
	local entries = {}
	local i, n = 1, #raw
	while i <= n do
		local sep = raw:find('\0', i, true)
		if not sep then break end
		local entry = raw:sub(i, sep - 1)
		i = sep + 1
		if #entry >= 4 then
			local x, y = entry:sub(1, 1), entry:sub(2, 2)
			local path = entry:sub(4)
			local old_path
			if x == 'R' or x == 'C' then
				local sep2 = raw:find('\0', i, true)
				if sep2 then
					old_path = raw:sub(i, sep2 - 1)
					i = sep2 + 1
				end
			end
			entries[#entries + 1] = { x = x, y = y, path = path, old_path = old_path }
		end
	end
	return entries
end

-- One porcelain entry yields 1 or 2 rows: a staged row, a working row, or
-- both. Untracked and unmerged are their own single-row sections.
local function split_entry(e)
	local rows = {}
	local xy = e.x .. e.y
	if e.x == '?' and e.y == '?' then
		rows[#rows + 1] = { side = '?', status = '?', path = e.path }
	elseif UNMERGED[xy] then
		rows[#rows + 1] = { side = '!', status = xy, path = e.path }
	else
		if e.x ~= ' ' and e.x ~= '?' and e.x ~= '!' then
			rows[#rows + 1] = { side = 'S', status = e.x, path = e.path, old_path = e.old_path }
		end
		if e.y ~= ' ' and e.y ~= '?' and e.y ~= '!' then
			rows[#rows + 1] = { side = 'W', status = e.y, path = e.path }
		end
	end
	return rows
end

local function in_scope(row, scope)
	if scope == 'all' then return true end
	if scope == 'staged' then return row.side == 'S' end
	if scope == 'unstaged' then
		return row.side == 'W' or row.side == '?' or row.side == '!'
	end
	if scope == 'untracked' then return row.side == '?' end
	if scope == 'unmerged' then return row.side == '!' end
	return false
end

-- Pad single-letter status to 2 cols so the path column lines up across
-- single-letter rows and two-letter unmerged rows.
local function build_text(row)
	local status = #row.status == 1 and (row.status .. ' ') or row.status
	local path = row.path
	if row.old_path then path = row.old_path .. ' -> ' .. path end
	return string.format('[%s] %s %s', row.side, status, path)
end

local function show(buf_id, items, query)
	require('mini.pick').default_show(buf_id, items, query, { show_icons = false })
	vim.api.nvim_buf_clear_namespace(buf_id, NS, 0, -1)
	for i, it in ipairs(items) do
		local lnum = i - 1
		local hl_tag = SIDE_HL[it.side]
		local hl_status = STATUS_HL[it.status:sub(1, 1)] or 'Normal'
		pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, 0,
			{ end_row = lnum, end_col = 3, hl_group = hl_tag, priority = 210 })
		pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, 4,
			{ end_row = lnum, end_col = 4 + #it.status, hl_group = hl_status, priority = 210 })
	end
end

local function set_diff_syntax(buf_id)
	local has_parser, parser = pcall(vim.treesitter.get_parser, buf_id, 'diff', { error = false })
	has_parser = has_parser and parser ~= nil
	if has_parser then has_parser = pcall(vim.treesitter.start, buf_id, 'diff') end
	if not has_parser then vim.bo[buf_id].syntax = 'diff' end
end

local function make_preview(cwd)
	return function(buf_id, item)
		if item == nil then return end
		if item.side == '?' then
			require('mini.pick').default_preview(buf_id, { path = item.abs_path })
			return
		end
		local args = { 'git', '-C', cwd, '--no-pager', 'diff' }
		if item.side == 'S' then table.insert(args, '--cached') end
		table.insert(args, '--')
		table.insert(args, item.rel_path)
		local r = vim.system(args):wait()
		local lines = vim.split(r.stdout or '', '\n', { plain = true })
		if lines[#lines] == '' then lines[#lines] = nil end
		vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
		set_diff_syntax(buf_id)
	end
end

M.git_status = function(local_opts, opts)
	local pick = require('mini.pick')
	if vim.fn.executable('git') ~= 1 then
		vim.notify('git_status: git not in PATH', vim.log.levels.ERROR)
		return
	end

	local cwd = repo_dir()
	if not cwd then
		vim.notify('git_status: not inside a Git repository', vim.log.levels.ERROR)
		return
	end

	local_opts = vim.tbl_deep_extend('force', { scope = 'all' }, local_opts or {})
	local allowed = { all = true, staged = true, unstaged = true, unmerged = true, untracked = true }
	if not allowed[local_opts.scope] then
		vim.notify(
			"git_status: scope must be one of 'all', 'staged', 'unstaged', 'unmerged', 'untracked'",
			vim.log.levels.ERROR
		)
		return
	end

	-- vim.system() preserves NUL bytes; vim.fn.system() would replace them
	-- with \x01 because Vimscript strings cannot hold NUL.
	local r = vim.system({
		'git', '-C', cwd, '-c', 'core.quotepath=false',
		'status', '--porcelain', '-z', '--untracked-files=all',
	}):wait()
	if r.code ~= 0 then
		vim.notify('git_status: git status failed:\n' .. (r.stderr or ''), vim.log.levels.ERROR)
		return
	end
	local raw = r.stdout or ''

	local rows = {}
	for _, e in ipairs(parse_porcelain(raw)) do
		for _, r in ipairs(split_entry(e)) do
			if in_scope(r, local_opts.scope) then rows[#rows + 1] = r end
		end
	end

	-- Stable section grouping: [S], [W], [?], [!], each section sorted by path.
	table.sort(rows, function(a, b)
		local sa, sb = SECTION_ORDER[a.side], SECTION_ORDER[b.side]
		if sa ~= sb then return sa < sb end
		return a.path < b.path
	end)

	local items = {}
	for _, r in ipairs(rows) do
		items[#items + 1] = {
			text = build_text(r),
			path = cwd .. '/' .. r.path,
			abs_path = cwd .. '/' .. r.path,
			rel_path = r.path,
			side = r.side,
			status = r.status,
			old_path = r.old_path,
		}
	end

	local name = string.format('Git status (%s)', local_opts.scope)
	return pick.start(vim.tbl_deep_extend('force', {
		source = {
			items = items,
			name = name,
			cwd = cwd,
			show = show,
			preview = make_preview(cwd),
		},
	}, opts or {}))
end

function M.register()
	require('mini.pick').registry.git_status = M.git_status
end

return M
