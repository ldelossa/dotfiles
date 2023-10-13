return {
	{
		"folke/which-key.nvim",
		opts = {
			defaults = {
				["<leader>W"] = { name = "+Workspace" },
				["<leader>Wb"] = { name = "+Bookmarks" },
				["<leader>Wg"] = { name = "+Git" },
			},
		},
	},
	{
		"ldelossa/nvim-ide",
		lazy = false,
		config = function()
			local bufferlist = require("ide.components.bufferlist")
			local explorer = require("ide.components.explorer")
			local outline = require("ide.components.outline")
			local callhierarchy = require("ide.components.callhierarchy")
			local timeline = require("ide.components.timeline")
			local terminal = require("ide.components.terminal")
			local terminalbrowser = require("ide.components.terminal.terminalbrowser")
			local changes = require("ide.components.changes")
			local commits = require("ide.components.commits")
			local branches = require("ide.components.branches")
			local bookmarks = require("ide.components.bookmarks")

			require("ide").setup({
				-- log_level = "debug",
				components = {
					global_keymaps = {
						hide = "h"
					},
					Explorer = {
						show_file_permissions = false,
						default_height = 30,
					},
					TerminalBrowser = {
						hidden = true
					},
				},
        panel_groups = {
            explorer = { explorer.Name,  outline.Name, bookmarks.Name, callhierarchy.Name, terminalbrowser.Name},
            terminal = { terminal.Name },
            git = { changes.Name, commits.Name, timeline.Name, branches.Name }
        },
				workspaces = {
					auto_open = "none",
				},
			})
		end,
		keys = {
			-- set keys based on the components you configured in setup
			{ "<leader>Wl", "<cmd>Workspace LeftPanelToggle<cr>", desc = "Toggle Left Panel" },
			{ "<leader>Wr", "<cmd>Workspace RightPanelToggle<cr>", desc = "Right Left Panel" },
			{ "<leader>We", "<cmd>Workspace Explorer Focus<cr>", desc = "Focus Explorer" },
			{ "<leader>e", "<cmd>Workspace Explorer Focus<cr>", desc = "Focus Explorer" },
			{ "<leader>Wo", "<cmd>Workspace Outline Focus<cr>", desc = "Focus Outline" },
			{ "<leader>Wbb", "<cmd>Workspace Bookmarks Focus<cr>", desc = "Focus Bookmarks" },
			{ "<leader>Wbo", "<cmd>Workspace Bookmarks OpenNotebook<cr>", desc = "Open Notebook" },
			{ "<leader>Wbc", "<cmd>Workspace Bookmarks CreateBookmark<cr>", desc = "Create Bookmark" },
			{ "<leader>Wgs", "<cmd>Workspace Changes Focus<cr>", desc = "Focus Changed Files" },
			{ "<leader>Wgc", "<cmd>Workspace Commits Focus<cr>", desc = "Focus Commits" },
			{ "<leader>Wgt", "<cmd>Workspace Timeline Focus<cr>", desc = "Focus Timeline" },
			{ "<leader>Wgb", "<cmd>Workspace Branches Focus<cr>", desc = "Focus Branches" },
			{ "<leader>gi", "<cmd>Workspace CallHierarchy IncomingCalls<cr>", desc = "Show Incoming Calls" },
			{ "<leader>go", "<cmd>Workspace CallHierarchy OutgoingCalls<cr>", desc = "Show Outgoing Calls" },
		},
	},
}
