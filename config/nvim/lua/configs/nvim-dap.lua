require('dapui').setup()

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
