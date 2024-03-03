--
-- Mini.nvim setup
--
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    '--branch', 'stable',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end

require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  require('mini.notify').setup()
	vim.notify = require('mini.notify').make_notify()
end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end)
later(function() require('mini.ai').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.clue').setup(
{
	-- Clue window settings
  window = {
    -- Floating window config
    config = {
			width = 40,
		},

    -- Delay before showing clue window
    delay = 100,

    -- Keys to scroll inside the clue window
    scroll_down = '<C-d>',
    scroll_up = '<C-u>',
  },
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- buffers key
    { mode = 'n', keys = '<C-b>' },

    -- tabs key
    { mode = 'n', keys = '<C-t>' },

    -- Marks
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },

    -- LSP namespace
    { mode = 'n', keys = '<C-l>' },

		-- Git namespace
    { mode = 'n', keys = '<C-g>' },
    { mode = 'i', keys = '<C-g>' },
    { mode = 'v', keys = '<C-g>' },
    { mode = 'o', keys = '<C-g>' },

    -- Movements
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.windows(),
    require('mini.clue').gen_clues.z(),
  },
}) end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.bufremove').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.basics').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.completion').setup({
	-- high delay basically means 'no auto popups'
  delay = { completion = 10^7, info = 10^7, signature = 10^7 },
 	-- Way of how module does LSP completion
  lsp_completion = {
    -- `source_func` should be one of 'completefunc' or 'omnifunc'.
    source_func = 'completefunc',
  },
}) end)
later(function() require('mini.extra').setup() end)
later(function() require('mini.fuzzy').setup() end)
later(function() require('mini.trailspace').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.indentscope').setup() end)
now(function() require('mini.sessions').setup({
  autoread = false,
  autowrite = true,
  file = 'Session.vim',
  force = { read = false, write = true, delete = false },
  hooks = {
    -- Before successful action
    pre = { read = nil, write = nil, delete = nil },
    -- After successful action
    post = { read = nil, write = nil, delete = nil },
  },
  verbose = { read = false, write = true, delete = true },
}) end)
now(function()
  local starter = require('mini.starter')
	starter.setup({
		autoopen = true,
    evaluate_single = true,
    items = {
      starter.sections.builtin_actions(),
      starter.sections.recent_files(10, false),
      starter.sections.recent_files(10, true),
      starter.sections.sessions(5, true)
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.indexing('all', { 'Builtin actions' }),
      starter.gen_hook.padding(3, 2),
    },
}) end)

--
-- Plugins
--

-- github theme
now(function()
  add('projekt0n/github-nvim-theme')
  require('github-theme').setup()
end)

-- everforest theme
now(function()
  add('neanias/everforest-nvim')
  require('everforest').setup()
  vim.cmd('colorscheme everforest')
end)

-- nightfox theme
now(function()
	add('EdenEast/nightfox.nvim')
	require('nightfox').setup()
end)

-- ayu theme
now(function()
	add('Shatur/neovim-ayu')
end)

-- web-devicons
now(function()
  add('nvim-tree/nvim-web-devicons')
  require('nvim-web-devicons').setup()
end)

-- lspconfig
now(function()
  add({ source = 'neovim/nvim-lspconfig', depends = { 'williamboman/mason.nvim' }, })
end)

-- nvim-treesitter
now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor = 'main',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["as"] = "@class.outer",
            ["is"] = "@class.inner",
            ["am"] = "@call.outer",
            ["im"] = "@call.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["a/"] = "@comment.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]s"] = "@class.outer",
            ["]a"] = "@parameter.outer",
            ["]m"] = "@call.outer",
            ["]b"] = "@block.outer",
            ["]i"] = "@conditional.outer",
            ["]l"] = "@loop.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]S"] = "@class.outer",
            ["]A"] = "@parameter.outer",
            ["]B"] = "@block.outer",
            ["]M"] = "@call.outer",
            ["]I"] = "@conditional.outer",
            ["]L"] = "@loop.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[s"] = "@class.outer",
            ["[a"] = "@parameter.outer",
            ["[m"] = "@call.outer",
            ["[b"] = "@block.outer",
            ["[i"] = "@conditional.outer",
            ["[l"] = "@loop.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[S"] = "@class.outer",
            ["[A"] = "@parameter.outer",
            ["[M"] = "@call.outer",
            ["[B"] = "@block.outer",
            ["[I"] = "@conditional.outer",
            ["[L"] = "@loop.outer",
          },
        },
      },
    })
end)

-- nvim-treesitter objects
now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    checkout = 'master',
    monitor = 'main',
  })
end)

-- gitsigns
now(function()
  add({
    source = 'lewis6991/gitsigns.nvim',
  })
	require('gitsigns').setup()
end)

-- github/copilot.vim
later(function()
	add({
		source = 'github/copilot.vim',
	})
	-- start with it always disabled and trigger completion
	vim.cmd("Copilot disable")
end)

--
-- LSP
--

-- write lua config which changes the diagnostic icons in the gutter to dots
vim.fn.sign_define(
  'DiagnosticSignError',
  { text = '', texthl = 'LspDiagnosticsDefaultError' }
)

vim.fn.sign_define(
  'DiagnosticSignWarn',
  { text = '', texthl = 'LspDiagnosticsDefaultWarning' }
)

vim.fn.sign_define(
  'DiagnosticSignInfo',
  { text = '', texthl = 'LspDiagnosticsDefaultInformation' }
)

vim.fn.sign_define(
  'DiagnosticSignHint',
  { text = '', texthl = 'LspDiagnosticsDefaultHint' }
)

vim.g.autoformat = false

-- disable virtual text for all diagnostic handlers.
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
})

local on_init = function(client, initialization_result)
	if client.server_capabilities then
		client.server_capabilities.semanticTokensProvider = false
	end
end

local nvim_lsp = require("lspconfig")
nvim_lsp.dockerls.setup({})
nvim_lsp.html.setup({})
nvim_lsp.jsonls.setup({})
nvim_lsp.tsserver.setup({})
nvim_lsp.vimls.setup({})
nvim_lsp.yamlls.setup({})
nvim_lsp.gopls.setup({})
nvim_lsp.zls.setup({})
nvim_lsp.clangd.setup({
	on_init = on_init,
	cmd = {
    "clangd",
    "--offset-encoding=utf-16",
  }
})

--
-- Keymaps
--

local opts = { silent = true }
local map = vim.keymap.set
vim.g.mapleader = " "

-- leader w for write
map("n", "<leader>w", "<cmd>w<cr>", {silent=true, desc="write"})

-- Arrow keys to adjust window size
map("n", "<Right>", "<cmd>vertical resize +2<cr>", opts)
map("n", "<Left>", "<cmd>vertical resize -2<cr>", opts)
map("n", "<Down>", "<cmd>resize +2<cr>", opts)
map("n", "<Up>", "<cmd>resize -2<cr>", opts)

-- append common characters characters
map("i", "<C-;>", "<Esc>A;<Esc>", opts)
map("i", "<C-e>", "<Esc>A }<Esc>", opts)
map("i", "<C-b>", "<Esc>A {<Esc>", opts)

-- buffer maps
map("n", "<C-b>n", "<cmd>bnext<cr>", {silent=true, desc="next buffer"})
map("n", "<C-b>p", "<cmd>bprevious<cr>", {silent=true, desc="previous buffer"})
map("n", "<C-b>d", "<cmd>lua require('mini.bufremove').delete()<cr>", {silent=true, desc="delete buffer"})
map("n", "<C-b>a", '<C-^>', {silent=true, desc="alternate buffer"})
map("n", "<C-b>o", function() vim.cmd('%bd|e#') end, {silent=true, desc="close other buffers"})
map("n", "bn", "<cmd>bnext<cr>", {silent=true, desc="next buffer"})
map("n", "bp", "<cmd>bprevious<cr>", {silent=true, desc="previous buffer"})
map("n", "bd", "<cmd>lua require('mini.bufremove').delete()<cr>", {silent=true, desc="delete buffer"})
map("n", "ba", '<C-^>', {silent=true, desc="alternate buffer"})
map("n", "bo", function() vim.cmd('%bd|e#') end, {silent=true, desc="close other buffers"})

-- terminal keybinds
map("t", "<C-w>n", "<C-\\><C-n>", opts)
map("t", "<C-w>h", "<C-\\><C-n><C-w>h", opts)
map("t", "<C-w>j", "<C-\\><C-n><C-w>j", opts)
map("t", "<C-w>k", "<C-\\><C-n><C-w>k", opts)
map("t", "<C-w>l", "<C-\\><C-n><C-w>l", opts)

-- tab maps
map("n", "<C-t>n", "<cmd>tabnext<cr>", {silent=true, desc="next tab"})
map("n", "<C-t>p", "<cmd>tabprevious<cr>", {silent=true, desc="previous tab"})
map("n", "<C-t>d", "<cmd>tabclose<cr>", {silent=true, desc="delete tab"})

-- mini
local explorer = function()
	local buf_name = vim.api.nvim_buf_get_name(0)
	-- check if buf_name is a valid file system path
	if vim.fn.filereadable(buf_name) == 1 then
		require('mini.files').open(buf_name)
	else
		require('mini.files').open()
	end
end
map("n", "<leader>f", explorer, {silent = true, desc = "mini.files"})
map("n", "'", "<cmd>Pick buffers<cr>", {silent=true, desc="mini.pick buffers"})
map("n", "<leader><leader>", "<cmd>Pick files<cr>", {silent=true, desc="mini.pick files"})

-- LSP
map("n", "<C-l>s", "<cmd>Pick lsp scope='document_symbol'<cr>", {silent=true, desc="document symbols"})
map("n", "<C-l>w", "<cmd>Pick lsp scope='workspace_symbol'<cr>", {silent=true, desc="workspace symbols"})
map("n", "<C-l>hi", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>", {silent=true, desc="incoming calls"})
map("n", "<C-l>ho", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>", {silent=true, desc="outgoing calls"})
map("n", "<C-l>p", "<cmd>lua vim.diagnostic.goto_prev({ float = false })<cr>", {silent=true, desc="previous diagnostic"})
map("n", "<C-l>n", "<cmd>lua vim.diagnostic.goto_next({ float = false })<cr>", {silent=true, desc="next diagnostic"})
map("n", "<C-l>h", "<Cmd>lua vim.lsp.buf.hover()<cr>", {silent=true, desc="hover info"})
map("n", "<leader>i", "<Cmd>lua vim.lsp.buf.hover()<cr>", {silent=true, desc="hover info"})
map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", {silent=true, desc="signature help"})
map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", {silent=true, desc="signature help"})
map("n", "<C-l>S", "<cmd>lua vim.lsp.buf.signature_help()<cr>", {silent=true, desc="signature help"})
map("i", "<C-l>S", "<cmd>lua vim.lsp.buf.signature_help()<cr>", {silent=true, desc="signature help"})
map("i", "<C-l>r", "<cmd>lua vim.lsp.buf.rename()<cr>", {silent=true, desc="rename symbol"})
map("n", "<C-l>r", "<cmd>lua vim.lsp.buf.rename()<cr>", {silent=true, desc="rename symbol"})
map("n", "<C-l>e", '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<cr>', {silent=true, desc="show error"})
map("i", "<C-l>e", '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<cr>', {silent=true, desc="show error"})
map("n", "<C-l>f", "<cmd>lua vim.lsp.buf.format()<cr>", {silent=true, desc="format"})
map("n", "<C-l>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", {silent=true, desc="code action"})
map("n", "<C-l>u", "<Cmd>Pick lsp scope='references'<cr>", {silent=true, desc="references of symbol"})
map("n", "<C-l>d", "<Cmd>Pick lsp scope='definition'<cr>", {silent=true, desc="definition of symbol"})
map("n", "gd", "<Cmd>Pick lsp scope='definition'<cr>", {silent=true, desc="definition of symbol"})
map("n", "<C-l>D", "<Cmd>Pick lsp scope='type_definition'<cr>", {silent=true, desc="type definition of symbol"})
map("n", "gD", "<Cmd>Pick lsp scope='type_definition'<cr>", {silent=true, desc="type definition of symbol"})
map("n", "<C-l>l", "<Cmd>Pick lsp scope='implementation'<cr>", {silent=true, desc="implementation of symbol"})

-- git
local gs = require('gitsigns')
map("n", "]h", gs.next_hunk, {silent=true, desc="next hunk"})
map("n", "[h", gs.prev_hunk, {silent=true, desc="prev hunk"})
map("n", "<c-g>n", gs.next_hunk, {silent=true, desc="next hunk"})
map("n", "<c-g>p", gs.prev_hunk, {silent=true, desc="prev hunk"})
map("n", "<c-g>s", ":gitsigns stage_hunk<cr>", {silent=true, desc="stage hunk"})
map("v", "<c-g>s", ":gitsigns stage_hunk<cr>", {silent=true, desc="stage hunk"})
map("n", "<c-g>u", gs.undo_stage_hunk, {silent=true, desc="undo stage hunk"})
map("n", "<c-g>r", ":gitsigns reset_hunk<cr>", {silent=true, desc="reset hunk"})
map("v", "<c-g>r", ":gitsigns reset_hunk<cr>", {silent=true, desc="reset hunk"})
map("n", "<c-g>S", gs.stage_buffer, {silent=true, desc="stage buffer"})
map("n", "<c-g>R", gs.reset_buffer, 	{silent=true, desc="reset buffer"})
map("n", "<c-g>P", gs.preview_hunk, {silent=true, desc="preview hunk"})
map("n", "<c-g>b", function() gs.blame_line({ full = true }) end, 	{silent=true, desc="blame line"})
map("n", "<c-g>d", gs.diffthis, {silent=true, desc="diff this"})
map("n", "<c-g>D", function() gs.diffthis("~") end, 	{silent=true, desc="diff this ~"})

-- copilot
map('i', '<C-j>', '<Plug>(copilot-suggest)', {silent=true, desc="copilot suggest"})
map('i', '<C-S-j>', '<Plug>(copilot-next)', {silent=true, desc="copilot next suggestion"})
map('i', '<C-S-k>', '<Plug>(copilot-previous)', {silent=true, desc="copilot previous suggestion"})
map('i', '<C-k>', '<Plug>(copilot-accept-word)', {silent=true, desc="copilot accept next word"})

-- mini pickers
map("n", "<leader>s", "<cmd>Pick grep<cr>", {silent=true, desc="grep"})
map("n", "<leader>S", "<cmd>Pick grep_live<cr>", {silent=true, desc="live grep"})
map("n", "<leader>m", "<cmd>Pick marks<cr>", {silent=true, desc="marks"})
map("n", "<leader>d", "<cmd>Pick diagnostic<cr>", {silent=true, desc="diagnostics"})
map("n", "<leader>g", "<cmd>Pick git_commits<cr>", {silent=true, desc="git commits"})
map("n", "<leader>H", "<cmd>Pick history<cr>", {silent=true, desc="history"})
map("n", "<leader>k", "<cmd>Pick keymaps<cr>", {silent=true, desc="keymaps"})
map("n", "<leader>t", function() require('mini.trailspace').trim() end, {silent=true, desc="trim trailing whitespace"})
map("n", "<leader>T", function() require('mini.trailspace').trim_last_line() end, {silent=true, desc="trim trailing empty lines"})
map("n", "<leader>r", "<cmd>Pick resume<cr>", {silent=true, desc="resume last picker"})
map("n", "<leader>h", "<cmd>Pick git_hunks<cr>", {silent=true, desc="git hunks"})

-- completion (inspired from mini.completion suggestion)
local keys = {
  ['tab']        = vim.api.nvim_replace_termcodes('<Tab>', true, true, true),
  ['ctrl-y']    = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
}
_G.tab_action = function()
  if vim.fn.pumvisible() ~= 0 then
    return keys['ctrl-y']
  else
    return keys['tab']
  end
end
vim.keymap.set('i', '<Tab>', 'v:lua._G.tab_action()', { expr = true })

--
-- Autocommands
--

-- a dumb way to do this, but certain codebases should use tabs with 8 spaces
-- cilium and kernel programming.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c" },
  callback = function()
    -- if current file's full path contains cilium set tabstop=8 and shiftwidth=8
    if vim.fn.expand("%:p:h"):match("cilium") then
      vim.api.nvim_command("setlocal tabstop=8 shiftwidth=8")
    end
    if vim.fn.expand("%:p:h"):match("linux") then
      vim.api.nvim_command("setlocal tabstop=8 shiftwidth=8")
    end
  end,
})

-- lau gets a spacing indentation of 2
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    vim.api.nvim_command("setlocal tabstop=2 shiftwidth=2")
    vim.api.nvim_command("setlocal tabstop=2 shiftwidth=2")
  end,
})

-- go is the only language that should format on save.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})

--
-- Options
--
local opt = vim.opt

opt.relativenumber = false
vim.opt.signcolumn = "yes"
opt.expandtab = false
opt.shiftwidth = 4
opt.tabstop = 4
opt.colorcolumn = "80"
vim.o.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.o.cmdheight=0

-- set c fileype for headers, not cpp
vim.g.c_syntax_for_h = 1

-- add commands to assist copying file and line numbers
vim.cmd('command! CopyDir let @+ = expand("%:p:h")')
vim.cmd('command! CopyPath let @+ = expand("%:p")')
vim.cmd('command! CopyPathLine let @+ = expand("%:p") . ":" . line(".")')
vim.cmd('command! CopyRel let @+ = expand("%")')
vim.cmd('command! CopyRelLine let @+ = expand("%"). ":" . line(".")')

-- set theme based on gnome's color-scheme settings
function set_dark_theme()
	 vim.cmd('set background=dark')
end
function set_light_theme()
	 vim.cmd('set background=light')
end
local function is_prefer_light_theme()
   -- Run the dconf command and capture the output
   local handle = io.popen("dconf read /org/gnome/desktop/interface/color-scheme")
   local result = handle:read("*a")
   handle:close()

   -- Trim any whitespace from the result
   result = string.gsub(result, "^%s*(.-)%s*$", "%1")

   -- Check the result and return true for 'prefer-light', false for 'prefer-dark'
   if result == "'prefer-light'" then
     return true
   elseif result == "'prefer-dark'" then
     return false
   else
     return nil
   end
 end

 -- if prefered light theme set background to light
 if is_prefer_light_theme() then
	 set_light_theme()
 else
	 set_dark_theme()
 end

