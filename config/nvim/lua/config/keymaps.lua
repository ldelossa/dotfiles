-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps hereby
--
local opts = { silent = true }
local map = vim.keymap.set

-- Telescope
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")

map("n", "'", function()
  builtin.buffers(themes.get_dropdown({
    previewer = false,
    sort_lastused = true,
    ignore_current_buffer = true,
  }))
end, opts)
map("n", "<leader>c", function()
  builtin.commands(themes.get_dropdown())
end, {})
map("n", "<leader><leader>", function()
  builtin.find_files(themes.get_dropdown({ previewer = false }))
end, {})

-- LSP
map("n", "<C-l>s", "<cmd>lua vim.lsp.buf.document_symbol()", opts)

map("n", "<C-l>w", "<cmd>lua vim.lsp.buf.workspace_symbol()", opts)

map("n", "<C-l>hi", "<cmd>lua vim.lsp.buf.incoming_calls()", opts)
map("n", "<C-l>ho", "<cmd>lua vim.lsp.buf.outgoing_calls()", opts)

map("n", "<C-l>p", "<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>", opts)
map("n", "<C-l>n", "<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>", opts)

map("n", "<C-l>h", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
map("n", "<leader>i", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)

map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
map("n", "<C-l>S", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
map("i", "<C-l>S", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

map("i", "<C-l>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
map("n", "<C-l>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

map("n", "<C-l>e", '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
map("i", "<C-l>e", '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)

map("n", "<leader>co", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
map("n", "<leader>ci", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)

map("n", "<C-l>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

map("n", "<C-l>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

-- if telescope is available, override some defaults above
if pcall(require, "telescope") then
  local builtin = require("telescope.builtin")
  local themes = require("telescope.themes")
  map("n", "<C-l>ee", "", {
    silent = true,
    noremap = true,
    callback = function()
      builtin.diagnostics({ bufnr = 0 })
    end,
  })
  map("n", "<leader>u", "", { silent = true, noremap = true, callback = builtin.lsp_references })
  map("n", "gi", "", { silent = true, noremap = true, callback = builtin.lsp_implementations })
  map("n", "gd", "", { silent = true, noremap = true, callback = builtin.lsp_definitions })
  map("n", "gdd", "", { silent = true, noremap = true, callback = builtin.lsp_type_definitions })

  map("n", "<C-l>s", "", {
    silent = true,
    noremap = true,
    callback = function()
      builtin.lsp_document_symbols(themes.get_dropdown({
        previewer = false,
      }))
    end,
  })
  map("n", "<leader>s", "", {
    silent = true,
    noremap = true,
    callback = function()
      builtin.lsp_document_symbols(themes.get_dropdown({
        previewer = false,
      }))
    end,
  })

  map("n", "<C-l>w", "", {
    silent = true,
    noremap = true,
    callback = function()
      builtin.lsp_workspace_symbols({ query = "" })
    end,
  })
  map("n", "<leader>W", "", {
    silent = true,
    noremap = true,
    callback = function()
      builtin.lsp_workspace_symbols({ query = "" })
    end,
  })

  map("n", "<C-l>hi", "", { silent = true, noremap = true, callback = builtin.lsp_incoming_calls })
  map("n", "<C-l>ho", "", { silent = true, noremap = true, callback = builtin.lsp_outgoing_calls })
  map("n", "<leader>hi", "", { silent = true, noremap = true, callback = builtin.lsp_incoming_calls })
  map("n", "<leader>ho", "", { silent = true, noremap = true, callback = builtin.lsp_outgoing_calls })

  map("n", "<C-l>ii", "", { silent = true, noremap = true, callback = builtin.lsp_implementations })
  map("n", "<leader>ii", "", { silent = true, noremap = true, callback = builtin.lsp_implementations })
end

-- if glance is available, override some more defaults above.
if pcall(require, "glance") then
  map("n", "<C-l>d", "<cmd>Glance definitions<CR>", opts)
  map("n", "<C-l>ii", "<cmd>Glance implementations<CR>", opts)
  map("n", "<C-l>u", "<cmd>Glance references<CR>", opts)
  map("n", "<C-l>dd", "<cmd>Glance type_definitions<CR>", opts)
end

map('i', '<Tab>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, { desc = "Super Tab" })
