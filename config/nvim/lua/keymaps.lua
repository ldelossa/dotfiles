local opts = { silent = true }
local map = vim.keymap.set
vim.g.mapleader = " "

-- mini.notification notification history
map("n", "<leader>n", "<cmd>lua require('mini.notify').show_history()<cr>", { silent = true, desc = "notifications" })

-- leader w for write
map("n", "<leader>w", "<cmd>w<cr>", { silent = true, desc = "write" })

-- Arrow keys to adjust window size
map("n", "<S-Right>", "<cmd>vertical resize +5<cr>", opts)
map("n", "<S-Left>", "<cmd>vertical resize -5<cr>", opts)
map("n", "<S-Down>", "<cmd>resize +5<cr>", opts)
map("n", "<S-Up>", "<cmd>resize -5<cr>", opts)

-- append common characters characters
map("i", "<C-;>", "<Esc>A;<Esc>", opts)
map("i", "<C-e>", "<Esc>A }<Esc>", opts)
map("i", "<C-b>", "<Esc>A {<Esc>", opts)

-- these are when barbar plugin not being used.
-- map("n", "bn", "<cmd>bnext<cr>", { silent = true, desc = "next buffer" })
-- map("n", "bp", "<cmd>bprevious<cr>", { silent = true, desc = "previous buffer" })
-- map("n", "<C-b>n", "<cmd>bnext<cr>", { silent = true, desc = "next buffer" })
-- map("n", "<C-b>p", "<cmd>bprevious<cr>", { silent = true, desc = "previous buffer" })

map("n", "<C-b>n", "<cmd>BufferNext<cr>", { silent = true, desc = "next buffer" })
map("n", "<C-b>p", "<cmd>BufferPrevious<cr>", { silent = true, desc = "previous buffer" })
map("n", "bn", "<cmd>BufferNext<cr>", { silent = true, desc = "next buffer" })
map("n", "bp", "<cmd>BufferPrevious<cr>", { silent = true, desc = "previous buffer" })
map("n", "<C-b>o", "<cmd>BufferCloseAllButCurrent<cr>", { silent = true, desc = "close other buffers" })
map("n", "bo", "<cmd>BufferCloseAllButCurrent<cr>", { silent = true, desc = "close other buffers" })

map("n", "<C-b>d", "<cmd>lua require('mini.bufremove').delete()<cr>", { silent = true, desc = "delete buffer" })
map("n", "<C-b>a", "<C-^>", { silent = true, desc = "alternate buffer" })
map("n", "bd", "<cmd>lua require('mini.bufremove').delete()<cr>", { silent = true, desc = "delete buffer" })
map("n", "ba", "<C-^>", { silent = true, desc = "alternate buffer" })
map("n", "<C-Tab>", "<C-^>", { silent = true, desc = "alternate buffer" })

-- terminal keybinds
map("t", "<C-w>n", "<C-\\><C-n>", opts)
map("t", "<C-w>h", "<C-\\><C-n><C-w>h", opts)
map("t", "<C-w>j", "<C-\\><C-n><C-w>j", opts)
map("t", "<C-w>k", "<C-\\><C-n><C-w>k", opts)
map("t", "<C-w>l", "<C-\\><C-n><C-w>l", opts)

-- tab maps
map("n", "<C-t>n", "<cmd>tabnext<cr>", { silent = true, desc = "next tab" })
map("n", "<C-t>p", "<cmd>tabprevious<cr>", { silent = true, desc = "previous tab" })
map("n", "<C-t>d", "<cmd>tabclose<cr>", { silent = true, desc = "delete tab" })

-- mini
local explorer = function()
	local buf_name = vim.api.nvim_buf_get_name(0)
	-- check if buf_name is a valid file system path
	if vim.fn.filereadable(buf_name) == 1 then
		require("mini.files").open(buf_name)
	else
		require("mini.files").open()
	end
end
map("n", "<leader>f", explorer, { silent = true, desc = "mini.files" })
map("n", "'", "<cmd>Pick buffers<cr>", { silent = true, desc = "mini.pick buffers" })
map("n", "<leader><leader>", "<cmd>Pick files<cr>", { silent = true, desc = "mini.pick files" })

local workspace_symbol_query = function()
	vim.ui.input({ prompt = "Symbol query: " }, function(input)
		if input == nil then
			return
		end
		require("mini.extra").pickers.lsp({ scope = "workspace_symbol", symbol_query = input })
	end)
end

-- LSP
map("i", "<C-Space>", "<cmd>lua vim.lsp.completion.trigger()<cr>", { silent = true, desc = "trigger lsp completion" })
map("n", "<C-l>s", "<cmd>Pick lsp scope='document_symbol'<cr>", { silent = true, desc = "document symbols" })
map("n", "<C-l>w", workspace_symbol_query, { silent = true, desc = "workspace symbols" })
map(
	"n",
	"<C-l>p",
	"<cmd>lua vim.diagnostic.jump({ count=-1, float=true })<cr>",
	{ silent = true, desc = "previous diagnostic" }
)
map(
	"n",
	"<C-l>n",
	"<cmd>lua vim.diagnostic.jump({ count=1, float=false })<cr>",
	{ silent = true, desc = "next diagnostic" }
)
map("n", "<C-l>b", require('dropbar.api').pick, { silent = true, desc = "breadcrumbs pick" })

-- will add a jump loc to the jump list before calling the command
local go = function(cmd)
	return function()
		vim.cmd("normal! m'")
		vim.cmd(cmd)
	end
end

-- map("n", "<C-l>u", go("Pick lsp scope='references'"), { silent = true, desc = "references of symbol" })
-- map("n", "<C-l>d", go("Pick lsp scope='definition"), { silent = true, desc = "definition of symbol" })
-- map("n", "gd", go("Pick lsp scope='definition'"), { silent = true, desc = "definition of symbol" })
-- map("n", "<C-l>l", go("Pick lsp scope='implementation'"), { silent = true, desc = "implementation of symbol" })
-- map("n", "<C-l>D", go("Pick lsp scope='type_definition'"), { silent = true, desc = "type definition of symbol" })
-- map("n", "gD", go("Pick lsp scope='type_definition'"), { silent = true, desc = "type definition of symbol" })

map("n", "<C-l>u", go("Glance references"), { silent = true, desc = "references of symbol" })
map("n", "<C-l>d", go("Glance definitions"), { silent = true, desc = "definition of symbol" })
map("n", "gd", go("Glance definitions"), { silent = true, desc = "definition of symbol" })
map("n", "<C-l>l", go("Glance implementations"), { silent = true, desc = "implementation of symbol" })
map("n", "<C-l>D", go("Glance type_definitions"), { silent = true, desc = "type definition of symbol" })
map("n", "gD", go("Glance type_definitions"), { silent = true, desc = "type definition of symbol" })
map("n", "<C-l>h", "<Cmd>lua vim.lsp.buf.hover()<cr>", { silent = true, desc = "hover info" })
map("n", "<leader>i", "<Cmd>lua vim.lsp.buf.hover()<cr>", { silent = true, desc = "hover info" })
map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true, desc = "signature help" })
map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true, desc = "signature help" })
map("n", "<C-l>k", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true, desc = "signature help" })
map("i", "<C-l>k", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true, desc = "signature help" })
map("i", "<C-l>r", "<cmd>lua vim.lsp.buf.rename()<cr>", { silent = true, desc = "rename symbol" })
map("n", "<C-l>r", "<cmd>lua vim.lsp.buf.rename()<cr>", { silent = true, desc = "rename symbol" })
map("n", "<C-l>e", '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<cr>', { silent = true, desc = "show error" })
map("i", "<C-l>e", '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<cr>', { silent = true, desc = "show error" })
map("n", "<C-l>f", "<cmd>lua vim.lsp.buf.format()<cr>", { silent = true, desc = "format" })
map("n", "<C-l>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", { silent = true, desc = "code action" })
map("n", "<C-l>x", "<cmd>Pick diagnostic<cr>", { silent = true, desc = "diagnostics" })
map("n", "<C-l>Hi", "<cmd>Workspace CallHierarchy IncomingCalls<cr>", { silent = true, desc = "incoming calls" })
map("n", "<C-l>Ho", "<cmd>Workspace CallHierarchy OutgoingCalls<cr>", { silent = true, desc = "outgoing calls" })

-- git
local gs = require("gitsigns")
map("n", "]h", gs.next_hunk, { silent = true, desc = "next hunk" })
map("n", "[h", gs.prev_hunk, { silent = true, desc = "prev hunk" })
map("n", "<c-g>n", gs.next_hunk, { silent = true, desc = "next hunk" })
map("n", "<c-g>p", gs.prev_hunk, { silent = true, desc = "prev hunk" })
map("n", "<c-g>s", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "stage hunk" })
map("v", "<c-g>s", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "stage hunk" })
map("n", "<c-g>u", gs.undo_stage_hunk, { silent = true, desc = "undo stage hunk" })
map("n", "<c-g>r", ":Gitsigns reset_hunk<cr>", { silent = true, desc = "reset hunk" })
map("v", "<c-g>r", ":Gitsigns reset_hunk<cr>", { silent = true, desc = "reset hunk" })
map("n", "<c-g>S", gs.stage_buffer, { silent = true, desc = "stage buffer" })
map("n", "<c-g>R", gs.reset_buffer, { silent = true, desc = "reset buffer" })
map("n", "<c-g>P", gs.preview_hunk, { silent = true, desc = "preview hunk" })
map("n", "<c-g>b", function()
	gs.blame_line({ full = true })
end, { silent = true, desc = "blame line" })
map("n", "<c-g>d", gs.diffthis, { silent = true, desc = "diff this" })
map("n", "<c-g>D", function()
	gs.diffthis("~")
end, { silent = true, desc = "diff this ~" })
map("n", "gl", ":GHInteractive<cr>", { silent = true, desc = "open location in GitHub (web)" })
map("v", "gl", ":GHInteractive<cr>", { silent = true, desc = "open location in GitHub (web)" })
map("n", "<c-g>h", ":Pick git_hunks<cr>", { silent = true, desc = "list git hunks" })

-- mini pickers
map("n", "<leader>s", "<cmd>Pick grep<cr>", { silent = true, desc = "grep" })
map("n", "<leader>S", "<cmd>Pick grep_live<cr>", { silent = true, desc = "live grep" })
map("n", "<leader>m", "<cmd>Pick marks<cr>", { silent = true, desc = "marks" })
map("n", "<leader>g", "<cmd>Pick git_commits<cr>", { silent = true, desc = "git commits" })
map("n", "<leader>H", "<cmd>Pick history<cr>", { silent = true, desc = "history" })
map("n", "<leader>k", "<cmd>Pick keymaps<cr>", { silent = true, desc = "keymaps" })
map("n", "<leader>t", function()
	require("mini.trailspace").trim()
end, { silent = true, desc = "trim trailing whitespace" })
map("n", "<leader>T", function()
	require("mini.trailspace").trim_last_line()
end, { silent = true, desc = "trim trailing empty lines" })
map("n", "<leader>r", "<cmd>Pick resume<cr>", { silent = true, desc = "resume last picker" })
map("n", "<leader>h", "<cmd>Pick git_hunks<cr>", { silent = true, desc = "git hunks" })
map("n", "<leader>R", "<cmd>Pick oldfiles<cr>", { silent = true, desc = "recent files" })
map("n", "<leader>d", require('mini.starter').open, { silent = true, desc = "open dashboard (mini.starter)" })

-- special handling for filepath completion.
-- cd to buffer's dir so filepath completion shows files relative to buffer's
-- directory, then switch back after extremely short delay
local filepath_completion = function()
	local cwd = vim.fn.getcwd()

	local buffer_dir = vim.fn.expand("%:p:h")
	vim.cmd("cd " .. buffer_dir)

	-- trigger filepath completion
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-X><C-F>", true, false, true), "n", false)

	-- change dir back after short delay
	vim.defer_fn(function()
		vim.cmd("cd " .. cwd)
	end, 1)
end
map("i", "<C-X><C-F>", filepath_completion, { silent = true, desc = "filepath completion" })

map("i", "<C-j>", require("copilot.suggestion").next, { silent = true, desc = "copilot suggest" })
map("i", "<C-S-j>", require("copilot.suggestion").prev, { silent = true, desc = "copilot previous suggest" })
map("i", "<C-h>", require("copilot.suggestion").accept_line, { silent = true, desc = "copilot accept next line" })
map("i", "<C-S-h>", require("copilot.suggestion").accept_word, { silent = true, desc = "copilot accept next word" })

-- super tab, make tab do different things depending on context.
local keys = {
	["tab"] = vim.api.nvim_replace_termcodes("<Tab>", true, true, true),
	["ctrl-y"] = vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
	["noop"] = vim.api.nvim_replace_termcodes("", true, true, true),
}
vim.g.super_tab = function()
	if vim.fn.pumvisible() ~= 0 then
		return keys["ctrl-y"]
	elseif require("copilot.suggestion").is_visible() then
		require("copilot.suggestion").accept()
		return keys["noop"]
  elseif require("mini.snippets").session.get() ~= nil then
		return '<cmd>lua MiniSnippets.session.jump("next")<cr>'
	else
		return keys["tab"]
	end
end
vim.keymap.set("i", "<Tab>", vim.g.super_tab, { expr = true })

-- nvim-ide
map("n", "<leader>e", "<cmd>Workspace LeftPanelToggle<cr>", { silent = true, desc = "toggle code explorer panel" })
map("n", "<leader>G", "<cmd>Workspace RightPanelToggle<cr>", { silent = true, desc = "toggle git explorer panel" })

-- CopilotChat
local chat = require("CopilotChat")
local select = require("CopilotChat.select")

local quick_chat = function()
	local input = vim.fn.input("Quick Chat: ")
	if input ~= "" then
		chat.ask(input, {
			selection = select.visual,
		})
	end
end

map("n", "<C-l>c", chat.open, { silent = true, desc = "open copilot chat" })
map("n", "<C-l>i", quick_chat, { silent = true, desc = "open copilot quick chat" })
map("i", "<C-l>i", quick_chat, { silent = true, desc = "open copilot quick chat" })
map("v", "<C-l>i", quick_chat, { silent = true, desc = "open copilot quick chat" })


local function open_file_and_navigate()
	local selected_text = ""
	-- select WORD using motion under the cursor and put it in selected_text
	vim.cmd("normal! viW\"+y")
	selected_text = vim.fn.getreg("+")

	-- split selected text into file_path, line_num, and col_num with ':' being the
	-- delimeter
	print(selected_text)
	local items = vim.fn.split(selected_text, ":", true)
	print(vim.inspect(items))
	local file_path = items[1]
	local line_num = items[2]
	local col_num = items[3]

	if not file_path then
		print("Invalid input format. Expected 'file_path:line_num:col_num:'")
		return
	end

	line_num = tonumber(line_num)
	if line_num == nil then
		line_num = 1
	end

	col_num = tonumber(col_num)
	if col_num == nil then
		col_num = 1
	else
		col_num = col_num - 1
	end

	-- Open the file
	vim.cmd("edit " .. file_path)
	vim.api.nvim_win_set_cursor(0, { line_num, col_num })
end

map("n", "gb", open_file_and_navigate, { silent = true, desc = "Open file with line and/or column" })
