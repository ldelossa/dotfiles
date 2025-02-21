-- syncs the working directory with a configured remote.

-- global so status bars can disable an icon when enabled
Rsync_Enabled = false

local uv = vim.uv

local sync_icon_1 = '⇄ '
local sync_icon_2 = '⇆ '
local sync_aucmd = nil
local host = nil

local debug = {
	buffer = nil,
	win = nil,
	enabled = false,
}

local swap_sync_icons = function()
	if vim.o.statusline:find(sync_icon_1) then
		vim.o.statusline = string.gsub(vim.o.statusline, sync_icon_1, sync_icon_2)
	else
		vim.o.statusline = string.gsub(vim.o.statusline, sync_icon_2, sync_icon_1)
	end
end

local remove_sync_icons = function()
	vim.o.statusline = string.gsub(vim.o.statusline, sync_icon_1, '')
	vim.o.statusline = string.gsub(vim.o.statusline, sync_icon_2, '')
end

local add_sync_icon = function()
	vim.o.statusline = vim.o.statusline .. sync_icon_1
end

local write_to_debug_buffer = function(data)
	if not debug.enabled then
		return
	end

	if not debug.buffer then
		debug.buffer = vim.api.nvim_create_buf(false, true)
	end
	if not debug.win or not vim.api.nvim_win_is_valid(debug.win) then
		debug.win = vim.api.nvim_open_win(debug.buffer, true, {
			relative = 'editor',
			width = 80,
			height = 30,
			row = 30,
			col = 30,
			style = 'minimal',
		})
	end

	local lines = vim.split(data, '\n')
	vim.api.nvim_buf_set_lines(debug.buffer, -1, -1, false, lines)
end

local rsync_async = function(args)
	local stdout = uv.new_pipe()
	local stderr = uv.new_pipe()

	local rsync_on_exit = function(code, _)
		if code ~= 0 then
			vim.notify('[rsync] sync failed with code: ' .. code, vim.log.levels.ERROR, {
				title = "rsync",
			})
		end
		stdout:close()
		stderr:close()
		vim.schedule(remove_sync_icons)
	end

	local on_read = function(err, data)
		if err then
			vim.notify('[rsync] error reading stdout: ' .. err, vim.log.levels.ERROR, {
				title = "rsync",
			})
			return
		end
		if data then
			vim.schedule(swap_sync_icons)
			if debug.enabled then
				vim.schedule(function() write_to_debug_buffer(data) end)
			end
		end
	end

	add_sync_icon()

	-- if debug write a new line with a time stamp
	if debug.enabled then
		vim.schedule(function() write_to_debug_buffer(os.date('--------%Y-%m-%d %H:%M:%S--------')) end)
	end

	uv.spawn("rsync", { args = args, stdio = { nil, stdout, stderr } }, rsync_on_exit)

	stdout:read_start(on_read)
	stderr:read_start(on_read)
end

local enable = function(cmd)
	if Rsync_Enabled then
		vim.notify('[rsync] already enabled for host: ' .. host, vim.log.levels.ERROR, {
			title = "rsync",
		})
		return
	end

	-- check if rsync binary is available
	if vim.fn.executable("rsync") == 0 then
		vim.notify('[rsync] rsync not in $PATH', vim.log.levels.ERROR, {
			title = "rsync",
		})
	end

	-- build arguments for a destructive sync of the current directory to the
	-- remote host the interoplated syntax looks like:
	-- rsync -e ssh --mkpath --delete -azv "$(pwd)"/ "$host":"$(pwd)"
	host = cmd.args
	local cwd = vim.fn.expand(vim.fn.getcwd())
	local args = { "-e", "ssh", "--mkpath", "--delete", "-azv", cwd .. '/', host .. ':' .. cwd }

	-- autocommand that runs on buffer write, will sync the cwd with the remote.
	sync_aucmd = vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "*",
		callback = function()
			rsync_async(args)
		end,
	})

	Rsync_Enabled = true

	vim.notify('[rsync] enabled for host: ' .. host, vim.log.levels.INFO, {
		title = "rsync",
	})
end

local disable = function()
	if not Rsync_Enabled then
		vim.notify('[rsync] not enabled', vim.log.levels.ERROR, {
			title = "rsync",
		})
	end

	vim.api.nvim_del_autocmd(sync_aucmd)

	Rsync_Enabled = false
	host = nil
end

local status = function()
	-- create popup window with status info
	if Rsync_Enabled then
		vim.notify('[rsync] enabled for host: ' .. host, vim.log.levels.INFO, {
			title = "rsync",
		})
	else
		vim.notify('[rsync] not enabled', vim.log.levels.INFO, {
			title = "rsync",
		})
	end
end

local enable_debug = function()
	debug.enabled = true
end

local disable_debug = function()
	debug.enabled = false

	if debug.win then
		vim.api.nvim_win_close(debug.win, true)
		debug.win = nil
	end

	if debug.buffer then
		vim.api.nvim_buf_delete(debug.buffer, { force = true })
		debug.buffer = nil
	end
end

vim.api.nvim_create_user_command('RsyncEnable', enable, { nargs = 1 })
vim.api.nvim_create_user_command('RsyncDisable', disable, { nargs = 0 })
vim.api.nvim_create_user_command('RsyncStatus', status, { nargs = 0 })
vim.api.nvim_create_user_command('RsyncEnableDebug', enable_debug, { nargs = 0 })
vim.api.nvim_create_user_command('RsyncDisableDebug', disable_debug, { nargs = 0 })
