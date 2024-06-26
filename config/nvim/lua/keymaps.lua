local opts = { silent = true }
local map = vim.keymap.set
vim.g.mapleader = " "

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

-- buffer maps
local close_other_buffers = function()
	local cur_buf = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		-- make sure buffer is a regular file type
		if vim.api.nvim_buf_get_option(buf, "buftype") ~= "" then
			goto continue
		end

		if buf ~= cur_buf then
			-- use this so mini's bufferline gets the hint
			require("mini.bufremove").delete(buf, true)
		end
		::continue::
	end
end

map("n", "<C-b>n", "<cmd>bnext<cr>", { silent = true, desc = "next buffer" })
map("n", "<C-b>p", "<cmd>bprevious<cr>", { silent = true, desc = "previous buffer" })
map("n", "<C-b>d", "<cmd>lua require('mini.bufremove').delete()<cr>", { silent = true, desc = "delete buffer" })
map("n", "<C-b>a", "<C-^>", { silent = true, desc = "alternate buffer" })
map("n", "<C-b>o", function()
	vim.cmd("%bd|e#")
end, { silent = true, desc = "close other buffers" })
map("n", "bn", "<cmd>bnext<cr>", { silent = true, desc = "next buffer" })
map("n", "bp", "<cmd>bprevious<cr>", { silent = true, desc = "previous buffer" })
map("n", "bd", "<cmd>lua require('mini.bufremove').delete()<cr>", { silent = true, desc = "delete buffer" })
map("n", "ba", "<C-^>", { silent = true, desc = "alternate buffer" })
map("n", "<C-Tab>", "<C-^>", { silent = true, desc = "alternate buffer" })
map("n", "bo", close_other_buffers, { silent = true, desc = "close other buffers" })

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
map("n", "<C-l>hi", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>", { silent = true, desc = "incoming calls" })
map("n", "<C-l>ho", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>", { silent = true, desc = "outgoing calls" })
map(
	"n",
	"<C-l>p",
	"<cmd>lua vim.diagnostic.goto_prev({ float = false })<cr>",
	{ silent = true, desc = "previous diagnostic" }
)
map(
	"n",
	"<C-l>n",
	"<cmd>lua vim.diagnostic.goto_next({ float = false })<cr>",
	{ silent = true, desc = "next diagnostic" }
)

-- will add a jump loc to the jump list before calling the command
local go = function(cmd)
	return function()
		vim.cmd("normal! m'")
		vim.cmd(cmd)
	end
end

map("n", "<C-l>h", "<Cmd>lua vim.lsp.buf.hover()<cr>", { silent = true, desc = "hover info" })
map("n", "<leader>i", "<Cmd>lua vim.lsp.buf.hover()<cr>", { silent = true, desc = "hover info" })
map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true, desc = "signature help" })
map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true, desc = "signature help" })
map("n", "<C-l>S", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true, desc = "signature help" })
map("i", "<C-l>S", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true, desc = "signature help" })
map("i", "<C-l>r", "<cmd>lua vim.lsp.buf.rename()<cr>", { silent = true, desc = "rename symbol" })
map("n", "<C-l>r", "<cmd>lua vim.lsp.buf.rename()<cr>", { silent = true, desc = "rename symbol" })
map("n", "<C-l>e", '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<cr>', { silent = true, desc = "show error" })
map("i", "<C-l>e", '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<cr>', { silent = true, desc = "show error" })
map("n", "<C-l>f", "<cmd>lua vim.lsp.buf.format()<cr>", { silent = true, desc = "format" })
map("n", "<C-l>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", { silent = true, desc = "code action" })
map("n", "<C-l>u", go("Pick lsp scope='references'"), { silent = true, desc = "references of symbol" })
map("n", "<C-l>d", go("Pick lsp scope='definition"), { silent = true, desc = "definition of symbol" })
map("n", "gd", go("Pick lsp scope='definition'"), { silent = true, desc = "definition of symbol" })
map("n", "<C-l>D", go("Pick lsp scope='type_definition'"), { silent = true, desc = "type definition of symbol" })
map("n", "gD", go("Pick lsp scope='type_definition'"), { silent = true, desc = "type definition of symbol" })
map("n", "<C-l>l", go("Pick lsp scope='implementation'"), { silent = true, desc = "implementation of symbol" })

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

-- copilot
map("i", "<C-j>", "<Plug>(copilot-suggest)", { silent = true, desc = "copilot suggest" })
map("i", "<C-S-j>", "<Plug>(copilot-next)", { silent = true, desc = "copilot next suggestion" })
map("i", "<C-S-k>", "<Plug>(copilot-previous)", { silent = true, desc = "copilot previous suggestion" })
map("i", "<C-h>", "<Plug>(copilot-accept-word)", { silent = true, desc = "copilot accept next word" })
map("i", "<C-S-h>", "<Plug>(copilot-accept-line)", { silent = true, desc = "copilot accept next word" })

-- mini pickers
map("n", "<leader>s", "<cmd>Pick grep<cr>", { silent = true, desc = "grep" })
map("n", "<leader>S", "<cmd>Pick grep_live<cr>", { silent = true, desc = "live grep" })
map("n", "<leader>m", "<cmd>Pick marks<cr>", { silent = true, desc = "marks" })
map("n", "<leader>d", "<cmd>Pick diagnostic<cr>", { silent = true, desc = "diagnostics" })
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

-- special handling for filepath completion.
-- cd to buffer's dir so filepath completion shows files relative to buffer's
-- directory.
-- then switch back after extremely short delay
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

-- completion (inspired from mini.completion suggestion)
local keys = {
	["tab"] = vim.api.nvim_replace_termcodes("<Tab>", true, true, true),
	["ctrl-y"] = vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
}
_G.tab_action = function()
	if vim.fn.pumvisible() ~= 0 then
		return keys["ctrl-y"]
	elseif vim.snippet.active({ direction = 1 }) then
		return '<cmd>lua vim.snippet.jump(1)<cr>'
	else
		return keys["tab"]
	end
end
vim.keymap.set("i", "<Tab>", "v:lua._G.tab_action()", { expr = true })

-- nvim-ide
map("n", "<leader>e", "<cmd>Workspace LeftPanelToggle<cr>", { silent = true, desc = "toggle code explorer panel" })
map("n", "<leader>G", "<cmd>Workspace RightPanelToggle<cr>", { silent = true, desc = "toggle git explorer panel" })
map("n", "<C-l>hi", "<cmd>Workspace CallHierarchy IncomingCalls<cr>", { silent = true, desc = "incoming calls" })
map("n", "<C-l>ho", "<cmd>Workspace CallHierarchy OutgoingCalls<cr>", { silent = true, desc = "outgoing calls" })
