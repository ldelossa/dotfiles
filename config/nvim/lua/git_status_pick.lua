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

local function build_items(cwd, scope)
	-- vim.system() preserves NUL bytes; vim.fn.system() would replace them
	-- with \x01 because Vimscript strings cannot hold NUL.
	local r = vim.system({
		'git', '-C', cwd, '-c', 'core.quotepath=false',
		'status', '--porcelain', '-z', '--untracked-files=all',
	}):wait()
	if r.code ~= 0 then
		vim.notify('git_status: git status failed:\n' .. (r.stderr or ''), vim.log.levels.ERROR)
		return {}
	end

	local rows = {}
	for _, e in ipairs(parse_porcelain(r.stdout or '')) do
		for _, row in ipairs(split_entry(e)) do
			if in_scope(row, scope) then rows[#rows + 1] = row end
		end
	end

	-- Stable section grouping: [S], [W], [?], [!], each section sorted by path.
	table.sort(rows, function(a, b)
		local sa, sb = SECTION_ORDER[a.side], SECTION_ORDER[b.side]
		if sa ~= sb then return sa < sb end
		return a.path < b.path
	end)

	local items = {}
	for _, row in ipairs(rows) do
		items[#items + 1] = {
			text = build_text(row),
			path = cwd .. '/' .. row.path,
			abs_path = cwd .. '/' .. row.path,
			rel_path = row.path,
			side = row.side,
			status = row.status,
			old_path = row.old_path,
		}
	end
	return items
end

local function current_item()
	local m = require('mini.pick').get_picker_matches()
	return m and m.current
end

local function refresh(cwd, scope)
	require('mini.pick').set_picker_items(build_items(cwd, scope))
end

local function run_git(cwd, args)
	local cmd = { 'git', '-C', cwd }
	for _, a in ipairs(args) do cmd[#cmd + 1] = a end
	local r = vim.system(cmd):wait()
	if r.code ~= 0 then
		vim.notify('git_status: ' .. (r.stderr or 'git failed'), vim.log.levels.ERROR)
		return false
	end
	return true
end

local function action_stage(cwd, scope)
	return function()
		local item = current_item()
		if not item then return end
		if item.side == 'S' then
			vim.notify('git_status: already staged', vim.log.levels.WARN)
			return
		end
		if run_git(cwd, { 'add', '--', item.rel_path }) then refresh(cwd, scope) end
	end
end

local function action_unstage(cwd, scope)
	return function()
		local item = current_item()
		if not item then return end
		if item.side ~= 'S' then
			vim.notify('git_status: not staged', vim.log.levels.WARN)
			return
		end
		if run_git(cwd, { 'restore', '--staged', '--', item.rel_path }) then refresh(cwd, scope) end
	end
end

local function action_discard(cwd, scope)
	return function()
		local item = current_item()
		if not item then return end
		if item.side == 'S' then
			vim.notify('git_status: unstage first, then discard', vim.log.levels.WARN)
			return
		end
		if item.side == '!' then
			vim.notify('git_status: cannot discard unmerged here', vim.log.levels.WARN)
			return
		end
		if vim.fn.confirm(string.format('Discard %s?', item.rel_path), '&No\n&Yes', 1) ~= 2 then
			return
		end
		if item.side == '?' then
			local ok = pcall(vim.fn.delete, item.abs_path)
			if not ok then
				vim.notify('git_status: failed to delete ' .. item.rel_path, vim.log.levels.ERROR)
				return
			end
		elseif item.side == 'W' then
			if not run_git(cwd, { 'restore', '--', item.rel_path }) then return end
		end
		refresh(cwd, scope)
	end
end

local function open_show_buffer(cwd, spec, display_name)
	local r = vim.system({ 'git', '-C', cwd, '--no-pager', 'show', spec }):wait()
	local lines = vim.split(r.stdout or '', '\n', { plain = true })
	if lines[#lines] == '' then lines[#lines] = nil end
	vim.cmd('enew')
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].buftype = 'nofile'
	vim.bo[buf].bufhidden = 'wipe'
	vim.bo[buf].swapfile = false
	pcall(vim.api.nvim_buf_set_name, buf, display_name)
	local ft = vim.filetype.match({ filename = display_name })
	if ft then vim.bo[buf].filetype = ft end
end

local function action_vimdiff(cwd)
	return function()
		local item = current_item()
		if not item then return end
		if item.side == '?' then
			vim.notify('git_status: untracked has no diff', vim.log.levels.WARN)
			return
		end
		if item.side == '!' then
			vim.notify('git_status: unmerged diff unsupported', vim.log.levels.WARN)
			return
		end
		require('mini.pick').stop()
		local side, abs_path, rel_path = item.side, item.abs_path, item.rel_path
		vim.schedule(function()
			if side == 'W' then
				vim.cmd('edit ' .. vim.fn.fnameescape(abs_path))
				vim.cmd('diffthis')
				vim.cmd('vert leftabove new')
				open_show_buffer(cwd, ':' .. rel_path, rel_path .. ' (index)')
				vim.cmd('diffthis')
				vim.cmd('wincmd p')
			else
				open_show_buffer(cwd, ':' .. rel_path, rel_path .. ' (index)')
				vim.cmd('diffthis')
				vim.cmd('vert leftabove new')
				open_show_buffer(cwd, 'HEAD:' .. rel_path, rel_path .. ' (HEAD)')
				vim.cmd('diffthis')
				vim.cmd('wincmd p')
			end
		end)
	end
end

local HELP_LINES = {
	'Git status picker:',
	'  <M-s>  stage',
	'  <M-u>  unstage',
	'  <M-r>  discard (confirms)',
	'  <M-d>  vimdiff',
	'  <F1>   show this help',
}

local function action_help()
	vim.notify(table.concat(HELP_LINES, '\n'), vim.log.levels.INFO)
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

	local scope = local_opts.scope
	local items = build_items(cwd, scope)
	local name = string.format('Git status (%s) — <F1> help', scope)

	return pick.start(vim.tbl_deep_extend('force', {
		source = {
			items = items,
			name = name,
			cwd = cwd,
			show = show,
			preview = make_preview(cwd),
		},
		mappings = {
			stage   = { char = '<M-s>', func = action_stage(cwd, scope) },
			unstage = { char = '<M-u>', func = action_unstage(cwd, scope) },
			discard = { char = '<M-r>', func = action_discard(cwd, scope) },
			vimdiff = { char = '<M-d>', func = action_vimdiff(cwd) },
			help    = { char = '<F1>',  func = action_help },
		},
	}, opts or {}))
end

function M.register()
	require('mini.pick').registry.git_status = M.git_status
end

return M
