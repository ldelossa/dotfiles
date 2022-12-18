require("dapui").setup({
  icons = { expanded = "", collapsed = "", current_frame = "" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        -- "console",
        "repl"
        -- {id = "repl", size = .75 },
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})

local function close_nvim_ide_panels()
    if pcall(require, 'ide') then
        local ws = require('ide.workspaces.workspace_registry').get_workspace(vim.api.nvim_get_current_tabpage())
        if ws ~= nil then
            ws.close_panel(require('ide.panels.panel').PANEL_POS_BOTTOM)
            ws.close_panel(require('ide.panels.panel').PANEL_POS_LEFT)
            ws.close_panel(require('ide.panels.panel').PANEL_POS_RIGHT)
        end
    end
end

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
    close_nvim_ide_panels()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
end

local cmd = vim.api.nvim_create_user_command

cmd('Dap', function() require 'telescope'.extensions.dap.commands(
        require 'telescope.themes'.get_dropdown({
            previewer = false,
        })
    )
end, {})
cmd('DapFrames', function() require 'telescope'.extensions.dap.frames(
        require 'telescope.themes'.get_dropdown({
            -- previewer = false,
        })
    )
end, {})
cmd('DapVars', function() require 'telescope'.extensions.dap.variables(
        require 'telescope.themes'.get_dropdown({
            -- previewer = false,
        })
    )
end, {})
cmd('DapClearBreakpoints', function() require('dap').clear_breakpoints() end, {})
cmd('DapShowLog', 'split | e ' .. vim.fn.stdpath('cache') .. '/dap.log | normal! G', {})
cmd('DapContinue', function() require('dap').continue() end, { nargs = 0 })
cmd('DapToggleBreakpoint', function() require('dap').toggle_breakpoint() end, { nargs = 0 })
cmd('DapToggleRepl', function() require('dap.repl').toggle() end, { nargs = 0 })
cmd('DapStepOver', function() require('dap').step_over() end, { nargs = 0 })
cmd('DapStepInto', function() require('dap').step_into() end, { nargs = 0 })
cmd('DapStepOut', function() require('dap').step_out() end, { nargs = 0 })
cmd('DapTerminate', function() require('dap').terminate() end, { nargs = 0 })
cmd('DapRestartFrame', function() require('dap').restart_frame() end, { nargs = 0 })
