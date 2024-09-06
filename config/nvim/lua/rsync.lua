-- syncs the working directory with

-- global so status bars can disable an icon when enabled
Rsync_Enabled = false

local uv = vim.uv

local sync_icon = '⇄ '
local sync_aucmd = nil
local host = nil

local rsync_on_exit = function(code, _)
	if code ~= 0 then
		vim.notify('[rsync] sync failed with code: ' .. code, vim.log.levels.ERROR, {
			title = "rsync",
		})
	end
	vim.schedule(function() vim.o.statusline = string.gsub(vim.o.statusline, sync_icon, '') end)
end

local rsync_async = function(args)
	vim.o.statusline = vim.o.statusline .. sync_icon
	uv.spawn("rsync", { args = args }, rsync_on_exit)
end

local enable = function(cmd)
	if Rsync_Enabled then
		vim.notify('[rsync] already enabled for host: ' .. host, vim.log.levels.ERROR, {
			title = "rsync",
		})
		return
	end

	-- check if cmds binary is available
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

vim.api.nvim_create_user_command('RsyncEnable', enable, { nargs = 1 })
vim.api.nvim_create_user_command('RsyncDisable', disable, { nargs = 0 })
vim.api.nvim_create_user_command('RsyncStatus', status, { nargs = 0 })
