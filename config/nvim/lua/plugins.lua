--
-- bootstrap mini.nvim
--
local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		-- Uncomment next line to use 'stable' branch
		"--branch",
		"stable",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
end

-- setup mini.deps for package management
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- configure mini.nvim
now(function()
	require("mini.notify").setup()
	vim.notify = require("mini.notify").make_notify()
end)
now(function()
	require("mini.basics").setup()
end)

local content = function()
	local mode, mode_hl = require("mini.statusline").section_mode({ trunc_width = 120 })
	local git           = require("mini.statusline").section_git({ trunc_width = 40 })
	local diff          = require("mini.statusline").section_diff({ trunc_width = 75 })
	local diagnostics   = require("mini.statusline").section_diagnostics({ trunc_width = 75 })
	local lsp           = require("mini.statusline").section_lsp({ trunc_width = 75 })
	local filename      = require("mini.statusline").section_filename({ trunc_width = 140 })
	local fileinfo      = require("mini.statusline").section_fileinfo({ trunc_width = 120 })
	local location      = require("mini.statusline").section_location({ trunc_width = 75 })
	local search        = require("mini.statusline").section_searchcount({ trunc_width = 75 })

	return require("mini.statusline").combine_groups({
		{
			hl = mode_hl,
			strings = { (function()
				if Rsync_Enabled then return '󰲁' else return '' end
			end)() }
		},
		{ hl = mode_hl,                             strings = { mode } },
		{ hl = 'require("mini.statusline")Devinfo', strings = { git, diff, diagnostics, lsp } },
		'%<', -- Mark general truncate point
		{ hl = 'require("mini.statusline")Filename', strings = { filename } },
		'%=', -- End left alignment
		{ hl = 'require("mini.statusline")Fileinfo', strings = { fileinfo } },
		{ hl = mode_hl,                              strings = { search, location } },
	})
end


now(function()
	require("mini.statusline").setup({
		content = {
			active = content
		}
	})
end)
now(function()
	require("mini.comment").setup()
end)
later(function()
	require("mini.ai").setup()
end)
later(function()
	require("mini.surround").setup()
end)
later(function()
	require("mini.clue").setup({
		-- Clue window settings
		window = {
			-- Floating window config
			config = {
				width = 40,
			},

			-- Delay before showing clue window
			delay = 100,

			-- Keys to scroll inside the clue window
			scroll_down = "<C-d>",
			scroll_up = "<C-u>",
		},
		triggers = {
			-- Leader triggers
			{ mode = "n", keys = "<Leader>" },
			{ mode = "x", keys = "<Leader>" },

			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },

			-- `g` key
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },

			-- `a` key
			{ mode = "n", keys = "a" },
			{ mode = "x", keys = "a" },

			-- `i` key
			{ mode = "n", keys = "i" },
			{ mode = "x", keys = "i" },

			-- buffers key
			{ mode = "n", keys = "<C-b>" },

			-- tabs key
			{ mode = "n", keys = "<C-t>" },

			-- Marks
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "`" },

			-- Registers
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },

			-- Window commands
			{ mode = "n", keys = "<C-w>" },

			-- `z` key
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },

			-- LSP namespace
			{ mode = "n", keys = "<C-l>" },

			-- Git namespace
			{ mode = "n", keys = "<C-g>" },
			{ mode = "i", keys = "<C-g>" },
			{ mode = "v", keys = "<C-g>" },
			{ mode = "o", keys = "<C-g>" },

			-- Movements
			{ mode = "n", keys = "[" },
			{ mode = "n", keys = "]" },

			-- Surrounds
			{ mode = "n", keys = "s" },
		},
		clues = {
			-- Enhance this by adding descriptions for <Leader> mapping groups
			require("mini.clue").gen_clues.builtin_completion(),
			require("mini.clue").gen_clues.g(),
			require("mini.clue").gen_clues.marks(),
			require("mini.clue").gen_clues.registers(),
			require("mini.clue").gen_clues.windows(),
			require("mini.clue").gen_clues.z(),
		},
	})
end)
-- later(function()
-- 	require("mini.completion").setup({
-- 		-- high delay basically means 'no auto popups'
-- 		delay = { completion = 10 ^ 7, info = 10 ^ 7, signature = 10 ^ 7 },
-- 		-- Way of how module does LSP completion
-- 		lsp_completion = {
-- 			-- `source_func` should be one of 'completefunc' or 'omnifunc'.
-- 			source_func = "omnifunc",
-- 		},
-- 	})
-- end)

later(function()
	require("mini.pick").setup({
		mappings = {
			choose_in_split   = '<C-S-s>',
			choose_in_tabpage = '<C-S-t>',
			choose_in_vsplit  = '<C-S-v>',
		}
	})
end)
later(function()
	require("mini.bufremove").setup()
end)
later(function()
	require("mini.pairs").setup(
		{
			-- In which modes mappings from this `config` should be created
			modes = { insert = true, command = false, terminal = false },
			-- Global mappings. Each right hand side should be a pair information, a
			-- table with at least these fields (see more in |MiniPairs.map|):
			-- - <action> - one of "open", "close", "closeopen".
			-- - <pair> - two character string for pair to be used.
			-- By default pair is not inserted after `\`, quotes are not recognized by
			-- `<CR>`, `'` does not insert pair after a letter.
			-- Only parts of tables can be tweaked (others will use these defaults).
			-- Supply `false` instead of table to not map particular key.
			mappings = {
				['('] = false,
				['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
				['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

				[')'] = false,
				[']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
				['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

				['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
				["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
				['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
			},
		}
	)
end)
later(function()
	require("mini.surround").setup()
end)
later(function()
	require("mini.align").setup()
end)
later(function()
	require("mini.extra").setup()
end)
later(function()
	require("mini.trailspace").setup()
end)
later(function()
	require("mini.files").setup({
		mappings = {
			close       = 'q',
			go_in       = 'L',
			go_in_plus  = '',
			go_out      = 'H',
			go_out_plus = '',
			reset       = '<BS>',
			reveal_cwd  = '@',
			show_help   = 'g?',
			synchronize = '=',
			trim_left   = '<',
			trim_right  = '>',
		},
	})
end)

-- ldelossa/auto-session
now(function()
	add({
		source = "ldelossa/auto-session",
	})
	require("auto-session").setup({
		auto_restore_enabled = false,
		auto_save_enabled = true,
		auto_session_use_git_branch = true,
	})
end)

local git_status_items = function()
	local edit_file = function(file)
		vim.cmd("e " .. file)
	end

	local status = vim.fn.systemlist("git status -s")

	local items = {}
	local limit = 15
	for _, line in ipairs(status) do
		if limit == 0 then
			break
		end

		local modifier = ""
		local file = ""
		local parts = vim.split(line, " ")

		if #parts == 2 then
			modifier = parts[1]
			file = parts[2]
		elseif #parts == 3 then
			modifier = parts[2]
			file = parts[3]
		end

		-- no need to display deleted file for opening.
		if modifier == "D" then
			goto continue
		end

		table.insert(items, {
			{
				section = "Git Status (limit 15)",
				name = line,
				action = function()
					edit_file(file)
				end,
			},
		})

		limit = limit - 1
		::continue::
	end

	return items
end

now(function()
	local starter = require("mini.starter")
	starter.setup({
		autoopen = true,
		evaluate_single = true,
		items = {
			starter.sections.builtin_actions(),
			function()
				if require("auto-session").session_exists_for_cwd() then
					return { section = "Sessions", name = "restore last session", action = [[SessionRestore]] }
				end
			end,
			function()
				if require("auto-session").session_exists_for_cwd() then
					return { section = "Sessions", name = "delete last session", action = [[SessionDelete]] }
				end
			end,
			starter.sections.recent_files(20, true),
			git_status_items(),
		},
		content_hooks = {
			starter.gen_hook.adding_bullet(),
			starter.gen_hook.indexing("all", { "Builtin actions" }),
			starter.gen_hook.padding(3, 2),
		},
	})
end)

--
-- Additional plugins
--

-- github theme
now(function()
	add("projekt0n/github-nvim-theme")
	require("github-theme").setup()
end)

-- everforest theme
now(function()
	add("sainnhe/everforest")
	vim.cmd("colorscheme everforest")
end)

-- nightfox theme
now(function()
	add("EdenEast/nightfox.nvim")
	require("nightfox").setup()
end)

-- shaunsingh/nord.nvim
now(function()
	add("shaunsingh/nord.nvim")
end)

-- web-devicons
now(function()
	add("nvim-tree/nvim-web-devicons")
	require("nvim-web-devicons").setup()
end)

-- lspconfig
now(function()
	add({ source = "neovim/nvim-lspconfig", depends = { "williamboman/mason.nvim" } })
end)

-- nvim-treesitter
now(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "master",
		monitor = "main",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	require("nvim-treesitter.configs").setup({
		highlight = { enable = true },
		fold = { enable = true },
		textobjects = {
			select = {
				enable = true,
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["ai"] = "@call.outer",
					["ii"] = "@call.inner",
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["al"] = "@loop.outer",
					["il"] = "@loop.inner",
					["at"] = "@conditional.outer",
					["it"] = "@conditional.inner",
					["a/"] = "@comment.outer",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]f"] = "@function.outer",
					["]s"] = "@class.outer",
					["]A"] = "@parameter.outer",
					["]i"] = "@call.outer",
					["]b"] = "@block.outer",
					["]t"] = "@conditional.outer",
					["]l"] = "@loop.outer",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]S"] = "@class.outer",
					["]a"] = "@parameter.outer",
					["]B"] = "@block.outer",
					["]I"] = "@call.outer",
					["]T"] = "@conditional.outer",
					["]L"] = "@loop.outer",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[s"] = "@class.outer",
					["[A"] = "@parameter.outer",
					["[i"] = "@call.outer",
					["[b"] = "@block.outer",
					["[t"] = "@conditional.outer",
					["[l"] = "@loop.outer",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[S"] = "@class.outer",
					["[a"] = "@parameter.outer",
					["[I"] = "@call.outer",
					["[B"] = "@block.outer",
					["[T"] = "@conditional.outer",
					["[L"] = "@loop.outer",
				},
			},
		},
	})
end)

-- nvim-treesitter objects
now(function()
	add({
		source = "nvim-treesitter/nvim-treesitter-textobjects",
		checkout = "master",
		monitor = "main",
	})
end)

-- gitsigns
now(function()
	add({
		source = "lewis6991/gitsigns.nvim",
	})
	require("gitsigns").setup()
end)

-- copilot.vim, used for suggestions, works much nicer then copilot.lua
later(function()
	add({
		source = "github/copilot.vim",
	})
	-- start with it always disabled and trigger completion
	vim.cmd("Copilot disable")
end)

-- yaml folds
now(function()
	add({
		source = "pedrohdz/vim-yaml-folds",
	})
end)

-- ldelossa/vim-gh-line
now(function()
	add({
		source = "ldelossa/vim-gh-line",
	})
end)

-- Bekaboo/dropbar.nvim
now(function()
	add({
		source = "Bekaboo/dropbar.nvim",
	})
end)

-- romgrk/barbar.nvim
now(function()
	add({
		source = "romgrk/barbar.nvim",
	})
	require("barbar").setup({
		sort = { ignore_case = true },
	})
end)
vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
	callback = vim.schedule_wrap(function()
		vim.cmd.BufferOrderByName()
	end)
})

-- nvim-ide
now(function()
	add({
		source = "ldelossa/nvim-ide",
	})

	require("ide").setup({
		-- The global icon set to use.
		-- values: "nerd", "codicon", "default"
		icon_set = "codicon",
		-- Set the log level for nvim-ide's log. Log can be accessed with
		-- 'Workspace OpenLog'. Values are 'debug', 'warn', 'info', 'error'
		log_level = "error",
		-- Component specific configurations and default config overrides.
		components = {
			-- The global keymap is applied to all Components before construction.
			-- It allows common keymaps such as "hide" to be overridden, without having
			-- to make an override entry for all Components.
			--
			-- If a more specific keymap override is defined for a specific Component
			-- this takes precedence.
			global_keymaps = {
				-- example, change all Component's hide keymap to "h"
				hide = h,
			},
			-- example, prefer "x" for hide only for Explorer component.
			-- Explorer = {
			--     keymaps = {
			--         hide = "x",
			--     }
			-- }
		},
		-- default panel groups to display on left and right.
		panels = {
			left = "explorer",
			right = "git",
		},
		-- panels defined by groups of components, user is free to redefine the defaults
		-- and/or add additional.
		panel_groups = {
			explorer = {
				require("ide.components.outline").Name,
				require("ide.components.callhierarchy").Name,
			},
			git = {
				require("ide.components.changes").Name,
				require("ide.components.commits").Name,
				require("ide.components.timeline").Name,
			},
		},
		-- workspaces config
		workspaces = {
			-- which panels to open by default, one of: 'left', 'right', 'both', 'none'
			auto_open = "none",
			-- on_quit = "close"
		},
		-- default panel sizes for the different positions
		panel_sizes = {
			left = 30,
			right = 30,
			bottom = 15,
		},
	})
end)

-- ldelossa/glance.nvim
now(function()
	add({
		source = "ldelossa/glance.nvim",
	})
	require("glance").setup({
		height = 25
	})
end)

-- zbirenbaum/copilot.lua
now(function()
	add({
		source = "zbirenbaum/copilot.lua",
	})
	require("copilot").setup()
end)

-- CopilotC-Nvim/CopilotChat.nvim, used for inline chat.
now(function()
	add({
		source = "CopilotC-Nvim/CopilotChat.nvim",
		checkout = "main",
		monitor = "main",
		depends = { "nvim-lua/plenary.nvim", }
	})
	require("CopilotChat").setup({
		auto_follow_cursor = false,
		window = {
			layout = "float",
			relative = "editor",
			height = 0.7,
			width = 0.8,
			anchor = "SW",
			row = 999,
			col = 999,
		},
	})
end)

-- mmarchini/bpftrace.vim
now(function()
	add({
		source = "mmarchini/bpftrace.vim",
	})
end)

-- nvim-lua/plenary.nvim
now(function()
	add({
		source = "nvim-lua/plenary.nvim",
	})
end)

-- nvim-telescope/telescope
now(function()
	add({
		source = "nvim-telescope/telescope.nvim",
	})
	require("telescope").setup({
	})
end)

-- pwntester/octo.nvim
now(function()
	add({
		source = "pwntester/octo.nvim",
	})
	require("octo").setup({
		use_local_fs = true,
		enable_builtin = true,
	})
end)
