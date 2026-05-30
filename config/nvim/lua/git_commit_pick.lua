-- mini.pick picker for `git log`. Each commit row can be expanded to reveal
-- its changed files as indented children. <CR> on a commit toggles
-- expansion; <CR> on a file opens a vimdiff against the commit's first
-- parent in a new tab. :q on either diff window tears the whole tab down.

local M = {}

local STATUS_HL = {
	M = 'DiagnosticWarn',
	A = 'DiagnosticOk',
	D = 'DiagnosticError',
	R = 'DiagnosticInfo',
	C = 'DiagnosticInfo',
	T = 'DiagnosticHint',
}

-- All single-glyph constants are 3-byte UTF-8; the byte width is reused for
-- highlight offsets in `show`.
local GLYPH_OPEN    = '▼'
local GLYPH_CLOSED  = '▶'
local GLYPH_CONNECT = '│'
local GLYPH_BYTES   = #GLYPH_OPEN

local DEFAULT_PAGE_SIZE = 1000

local NS = vim.api.nvim_create_namespace('mini-pick-git-commit')

local function repo_dir()
	local r = vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait()
	if r.code ~= 0 then return nil end
	local top = (r.stdout or ''):gsub('%s+$', '')
	if top == '' then return nil end
	return top
end

-- \x1f separates fields, \n separates records. `%s` (subject) is single-line
-- by Git convention, so newline-as-record is safe. `skip` lets the picker
-- page through long histories.
local function list_commits(cwd, page_size, skip)
	local fmt = '%H%x1f%h%x1f%s%x1f%an%x1f%ar'
	local r = vim.system({
		'git', '-C', cwd, '--no-pager', 'log',
		'--max-count=' .. tostring(page_size),
		'--skip=' .. tostring(skip or 0),
		'--pretty=format:' .. fmt,
	}):wait()
	if r.code ~= 0 then
		vim.notify('git_commit: git log failed:\n' .. (r.stderr or ''), vim.log.levels.ERROR)
		return {}
	end
	local commits = {}
	for line in (r.stdout or ''):gmatch('[^\n]+') do
		local h, short, subj, author, when =
			line:match('([^\x1f]+)\x1f([^\x1f]+)\x1f([^\x1f]*)\x1f([^\x1f]+)\x1f(.+)')
		if h then
			commits[#commits + 1] = {
				sha = h, short = short, subject = subj, author = author, when = when,
			}
		end
	end
	return commits
end

-- Commit metadata block shown above the file list on expand: author + email,
-- ISO date, and the body (if any). Empty body just means the trailing block
-- is the date line. Returned as plain lines so build_items can splice them
-- straight into items.
local function fetch_info(cwd, sha)
	local fmt = 'Author: %an <%ae>%nDate:   %ai%n%n%b'
	local r = vim.system({
		'git', '-C', cwd, '--no-pager', 'show', '-s', '--pretty=format:' .. fmt, sha,
	}):wait()
	if r.code ~= 0 then return {} end
	local text = (r.stdout or ''):gsub('\r\n', '\n'):gsub('%s+$', '')
	if text == '' then return {} end
	return vim.split(text, '\n', { plain = true })
end

-- Files changed in a commit. `-m --first-parent` makes merge commits show the
-- diff against their first parent (a non-merge commit ignores both).
-- `--no-renames` keeps the format uniform. With `-z`, each entry is a pair
-- of NUL-terminated chunks: `<status>\0<path>\0` (no tab — that's the
-- non-`-z` format).
local function list_files_for_commit(cwd, sha)
	local r = vim.system({
		'git', '-C', cwd, '-c', 'core.quotepath=false',
		'show', '--pretty=format:', '--name-status', '-z', '--no-renames',
		'-m', '--first-parent', sha,
	}):wait()
	if r.code ~= 0 then return {} end
	local raw = r.stdout or ''
	local files = {}
	local i, n = 1, #raw
	-- pretty=format: is empty but may still emit a leading NUL/newline before
	-- the name-status block; skip leading separators.
	while i <= n and (raw:sub(i, i) == '\0' or raw:sub(i, i) == '\n') do
		i = i + 1
	end
	while i <= n do
		local nul1 = raw:find('\0', i, true)
		if not nul1 then break end
		local status = raw:sub(i, nul1 - 1)
		local nul2 = raw:find('\0', nul1 + 1, true)
		if not nul2 then break end
		local path = raw:sub(nul1 + 1, nul2 - 1)
		files[#files + 1] = { status = status:sub(1, 1), path = path }
		i = nul2 + 1
	end
	return files
end

local function build_items(state)
	local items = {}
	for _, c in ipairs(state.commits) do
		local expanded = state.expanded[c.sha]
		local glyph = expanded and GLYPH_OPEN or GLYPH_CLOSED
		items[#items + 1] = {
			kind    = 'commit',
			sha     = c.sha,
			short   = c.short,
			subject = c.subject,
			author  = c.author,
			when    = c.when,
			text    = string.format('%s %s  %s  (%s, %s)',
				glyph, c.short, c.subject, c.author, c.when),
		}
		if expanded then
			-- Nested fold: a Details header that expands to author/date/body.
			-- Collapsed by default so the file list stays one keystroke away.
			local d_open = state.details_expanded[c.sha]
			local d_glyph = d_open and GLYPH_OPEN or GLYPH_CLOSED
			items[#items + 1] = {
				kind = 'details',
				sha  = c.sha,
				text = string.format('    %s Details', d_glyph),
			}
			if d_open then
				-- '│' sits at the same column as the Details chevron above,
				-- extending the open fold visually down through the info block.
				for _, line in ipairs(state.infos[c.sha] or {}) do
					items[#items + 1] = {
						kind = 'info',
						sha  = c.sha,
						text = string.format('    %s %s', GLYPH_CONNECT, line),
					}
				end
			end
			for _, f in ipairs(state.files[c.sha] or {}) do
				items[#items + 1] = {
					kind   = 'file',
					sha    = c.sha,
					status = f.status,
					path   = f.path,
					text   = string.format('    [%s] %s', f.status, f.path),
				}
			end
		end
	end
	if state.has_more then
		items[#items + 1] = {
			kind = 'more',
			text = string.format('··· load %d more (showing %d) ···',
				state.page_size, #state.commits),
		}
	end
	return items
end

local function show(buf_id, items, query)
	require('mini.pick').default_show(buf_id, items, query, { show_icons = false })
	vim.api.nvim_buf_clear_namespace(buf_id, NS, 0, -1)
	for i, it in ipairs(items) do
		local lnum = i - 1
		if it.kind == 'commit' then
			pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, 0,
				{ end_row = lnum, end_col = GLYPH_BYTES, hl_group = 'Special', priority = 210 })
			local sha_start = GLYPH_BYTES + 1
			pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, sha_start,
				{ end_row = lnum, end_col = sha_start + #it.short, hl_group = 'Identifier', priority = 210 })
		elseif it.kind == 'details' then
			-- 4 spaces of indent, then a chevron, then ' Details'.
			pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, 4,
				{ end_row = lnum, end_col = 4 + GLYPH_BYTES, hl_group = 'Special', priority = 210 })
			local label_start = 4 + GLYPH_BYTES + 1
			pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, label_start,
				{ end_row = lnum, end_line = lnum + 1, hl_group = 'Title', priority = 210 })
		elseif it.kind == 'info' then
			-- 4 spaces + '│' (3 bytes) + space + info text. Bar is Special
			-- so it matches the chevron above; the text after is dim Comment.
			pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, 4,
				{ end_row = lnum, end_col = 4 + GLYPH_BYTES, hl_group = 'Special', priority = 210 })
			pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, 4 + GLYPH_BYTES + 1,
				{ end_row = lnum, end_line = lnum + 1, hl_group = 'Comment', priority = 210 })
		elseif it.kind == 'file' then
			-- 4 spaces of indent, then '[X]'. Highlight just the X.
			local col = 5
			pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, col,
				{ end_row = lnum, end_col = col + 1, hl_group = STATUS_HL[it.status] or 'Normal', priority = 210 })
		elseif it.kind == 'more' then
			pcall(vim.api.nvim_buf_set_extmark, buf_id, NS, lnum, 0,
				{ end_row = lnum, end_line = lnum + 1, hl_group = 'Comment', priority = 210 })
		end
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
		if item == nil or item.kind == 'more' then return end
		local args
		if item.kind == 'file' then
			args = {
				'git', '-C', cwd, '--no-pager', 'show',
				'-m', '--first-parent', item.sha, '--', item.path,
			}
		else
			-- commit or body: show the whole commit (stat + patch).
			args = {
				'git', '-C', cwd, '--no-pager', 'show', '--stat', '--patch',
				'-m', '--first-parent', item.sha,
			}
		end
		local r = vim.system(args):wait()
		local lines = vim.split(r.stdout or '', '\n', { plain = true })
		if lines[#lines] == '' then lines[#lines] = nil end
		vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
		set_diff_syntax(buf_id)
	end
end

local function current_item()
	local m = require('mini.pick').get_picker_matches()
	return m and m.current
end

-- Same rank-preservation pattern as git_status_pick: filter order may differ
-- after set_picker_items, but pinning the visual rank keeps the cursor on
-- the same line so an expand doesn't yank the user away.
local function get_visible_rank()
	local m = require('mini.pick').get_picker_matches()
	if not m or not m.current_ind or not m.all_inds then return nil end
	for i, ind in ipairs(m.all_inds) do
		if ind == m.current_ind then return i end
	end
	return nil
end

local function restore_visible_rank(rank)
	if rank == nil then return end
	vim.schedule(function()
		local pick = require('mini.pick')
		if not pick.is_picker_active() then return end
		local m = pick.get_picker_matches()
		if not m or not m.all_inds or #m.all_inds == 0 then return end
		local target = math.min(rank, #m.all_inds)
		pick.set_picker_match_inds({ m.all_inds[target] }, 'current')
	end)
end

local function toggle_expand(cwd, state, sha)
	if state.expanded[sha] then
		state.expanded[sha] = nil
	else
		if not state.files[sha] then
			state.files[sha] = list_files_for_commit(cwd, sha)
		end
		state.expanded[sha] = true
	end
	local rank = get_visible_rank()
	require('mini.pick').set_picker_items(build_items(state))
	restore_visible_rank(rank)
end

local function toggle_details_expand(cwd, state, sha)
	if state.details_expanded[sha] then
		state.details_expanded[sha] = nil
	else
		if not state.infos[sha] then
			state.infos[sha] = fetch_info(cwd, sha)
		end
		state.details_expanded[sha] = true
	end
	local rank = get_visible_rank()
	require('mini.pick').set_picker_items(build_items(state))
	restore_visible_rank(rank)
end

-- Append the next page of commits in place. Heuristic for `has_more`: if the
-- fetch returned a full page, assume there's at least one more page; an empty
-- or short return locks it off so the sentinel stops appearing.
local function load_more(cwd, state)
	local more = list_commits(cwd, state.page_size, #state.commits)
	if #more < state.page_size then state.has_more = false end
	for _, c in ipairs(more) do
		state.commits[#state.commits + 1] = c
	end
	local rank = get_visible_rank()
	require('mini.pick').set_picker_items(build_items(state))
	restore_visible_rank(rank)
end

-- Both diff sides are scratch buffers with bufhidden=wipe. :q on either
-- window wipes its buffer, fires BufWinLeave, and the once-autocmd closes
-- the whole tab on the next event loop tick. The shared `fired` flag stops
-- the second buffer from re-firing after the tab is gone.
local function arm_tab_teardown(tab_id, bufs)
	local fired = false
	for _, buf in ipairs(bufs) do
		vim.api.nvim_create_autocmd('BufWinLeave', {
			buffer = buf,
			once = true,
			callback = function()
				if fired then return end
				fired = true
				vim.schedule(function()
					if vim.api.nvim_tabpage_is_valid(tab_id) then
						pcall(vim.cmd, 'tabclose ' .. vim.api.nvim_tabpage_get_number(tab_id))
					end
				end)
			end,
		})
	end
end

local function close_prior_diff_tab()
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		if vim.api.nvim_tabpage_is_valid(tab) then
			local ok, marked = pcall(vim.api.nvim_tabpage_get_var, tab, 'git_commit_diff')
			if ok and marked then
				pcall(vim.cmd, 'tabclose ' .. vim.api.nvim_tabpage_get_number(tab))
			end
		end
	end
end

-- Populate the current buffer from `git show <spec>`. spec == nil means the
-- file didn't exist at that revision (added file, or root-commit parent) —
-- show an empty buffer so the diff still aligns.
local function fill_show_buffer(cwd, spec, display_name, ft_path)
	local lines = {}
	if spec then
		local r = vim.system({ 'git', '-C', cwd, '--no-pager', 'show', spec }):wait()
		if r.code == 0 then
			lines = vim.split(r.stdout or '', '\n', { plain = true })
			if lines[#lines] == '' then lines[#lines] = nil end
		end
	end
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].buftype = 'nofile'
	vim.bo[buf].bufhidden = 'wipe'
	vim.bo[buf].swapfile = false
	pcall(vim.api.nvim_buf_set_name, buf, display_name)
	local ft = vim.filetype.match({ filename = ft_path or display_name })
	if ft then vim.bo[buf].filetype = ft end
	return buf
end

local function open_commit_diff(cwd, sha, path)
	close_prior_diff_tab()
	vim.cmd('tabnew')
	local tab_id = vim.api.nvim_get_current_tabpage()
	vim.api.nvim_tabpage_set_var(tab_id, 'git_commit_diff', true)

	-- Right: file at <sha>.
	local short = sha:sub(1, 8)
	local right_buf = fill_show_buffer(cwd, sha .. ':' .. path,
		path .. ' (' .. short .. ')', path)
	vim.cmd('diffthis')

	-- Left: file at first parent. Root commit has no parent → empty buffer.
	vim.cmd('vert leftabove new')
	local parent_r = vim.system({
		'git', '-C', cwd, 'rev-parse', '--verify', '--quiet', sha .. '^',
	}):wait()
	local left_spec, left_name
	if parent_r.code == 0 then
		local parent_short = (parent_r.stdout or ''):gsub('%s+$', ''):sub(1, 8)
		left_spec = sha .. '^:' .. path
		left_name = path .. ' (' .. parent_short .. ')'
	else
		left_name = path .. ' (no parent)'
	end
	local left_buf = fill_show_buffer(cwd, left_spec, left_name, path)
	vim.cmd('diffthis')
	vim.cmd('wincmd p')

	arm_tab_teardown(tab_id, { left_buf, right_buf })
end

M.git_commit = function(local_opts, opts)
	local pick = require('mini.pick')
	if vim.fn.executable('git') ~= 1 then
		vim.notify('git_commit: git not in PATH', vim.log.levels.ERROR)
		return
	end
	local cwd = repo_dir()
	if not cwd then
		vim.notify('git_commit: not inside a Git repository', vim.log.levels.ERROR)
		return
	end

	local_opts = vim.tbl_deep_extend('force', { page_size = DEFAULT_PAGE_SIZE }, local_opts or {})

	local initial = list_commits(cwd, local_opts.page_size, 0)
	local state = {
		commits   = initial,
		expanded  = {},
		files     = {},
		infos     = {},
		details_expanded = {},
		page_size = local_opts.page_size,
		has_more  = #initial >= local_opts.page_size,
	}

	local name = string.format('Git commits  CR:expand/diff')

	return pick.start(vim.tbl_deep_extend('force', {
		source = {
			items   = build_items(state),
			name    = name,
			cwd     = cwd,
			show    = show,
			preview = make_preview(cwd),
			-- choose: mini.pick stops when this returns nil/false and keeps
			-- the picker open on a truthy return (see pick.lua H.picker_choose).
			choose  = function(item)
				if not item then return end
				if item.kind == 'commit' then
					toggle_expand(cwd, state, item.sha)
					return true
				end
				if item.kind == 'details' then
					toggle_details_expand(cwd, state, item.sha)
					return true
				end
				if item.kind == 'info' then
					return true  -- informational; <CR> is a no-op
				end
				if item.kind == 'more' then
					load_more(cwd, state)
					return true
				end
				-- file row: schedule the diff tab and let the picker close.
				local sha, path = item.sha, item.path
				vim.schedule(function() open_commit_diff(cwd, sha, path) end)
			end,
		},
	}, opts or {}))
end

function M.register()
	require('mini.pick').registry.git_commit = M.git_commit
end

return M
